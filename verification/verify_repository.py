"""Recompute published SQL locally; optionally verify the stored Power BI model.

This is not native BigQuery execution or prospective model validation.
"""
import argparse
import hashlib
import io
import json
from pathlib import Path
import re
import zipfile

import duckdb
import pandas as pd
import sqlglot

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_SHA256 = "d1513ec63b385506f7cfce9f2c5caa9fe99e7ba4e8c3fa264b3aaf0f849ed32d"


def read_source(path):
    if path.suffix == ".csv":
        return path.read_bytes()
    with zipfile.ZipFile(path) as archive:
        if "bank-full.csv" in archive.namelist():
            return archive.read("bank-full.csv")
        with zipfile.ZipFile(io.BytesIO(archive.read("bank.zip"))) as bank:
            return bank.read("bank-full.csv")


def compare_rows(left, right, columns):
    # Ignore storage order, retain duplicate multiplicity, and use matching dtypes.
    left = left[columns].convert_dtypes()
    right = right[columns].convert_dtypes()
    a = pd.util.hash_pandas_object(left, index=False).sort_values().reset_index(drop=True)
    b = pd.util.hash_pandas_object(right, index=False).sort_values().reset_index(drop=True)
    if not a.equals(b):
        raise ValueError("Record multiset mismatch")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="UCI ZIP, bank.zip, or bank-full.csv")
    parser.add_argument("--check-pbix", action="store_true")
    parser.add_argument("--export", action="store_true", help="Replace deterministic local result CSVs")
    args = parser.parse_args()
    source_bytes = read_source(args.source)
    checksum = hashlib.sha256(source_bytes).hexdigest()
    if checksum != EXPECTED_SHA256:
        raise ValueError(f"Unexpected source checksum: {checksum}")
    source = pd.read_csv(io.BytesIO(source_bytes), sep=";")
    for column in ["default", "housing", "loan", "y"]:
        if not source[column].isin(["yes", "no"]).all():
            raise ValueError(f"Unexpected Boolean category in {column}")
        source[column] = source[column].map({"yes": True, "no": False})
    if len(source) != 45211 or source.y.sum() != 5289:
        raise ValueError("Baseline mismatch")

    connection = duckdb.connect()
    connection.register("raw", source)
    outputs = {}
    for path in sorted((ROOT / "sql").glob("[0-9][0-9]_*.sql")):
        query = path.read_text()
        for published, local in [
            ("bank_campaigns_raw", "raw"),
            ("crm_priority_segments_v1", "v1"),
            ("crm_priority_segments_v2", "v2"),
        ]:
            query = query.replace(
                f"`bank-marketing-crm.bank_marketing_crm.{published}`", f"`{local}`"
            )
        translated = sqlglot.transpile(query, read="bigquery", write="duckdb")[0]
        result = connection.execute(translated).fetchdf()
        outputs[path.name[:2]] = result
        if not path.name.startswith(("08_", "11_", "15_")):
            # COUNTIF translation may yield floating counts; export them as integers.
            for column in result.columns:
                if column not in {"conversion_rate_percent", "share_of_records_percent",
                                  "share_of_subscriptions_percent", "conversion_lift"}:
                    if pd.api.types.is_numeric_dtype(result[column]):
                        result[column] = result[column].astype("int64")
            target = ROOT / "results" / path.with_suffix(".csv").name
            if args.export:
                target.parent.mkdir(exist_ok=True)
                result.to_csv(target, index=False)
            else:
                expected = pd.read_csv(target)
                pd.testing.assert_frame_equal(
                    result.reset_index(drop=True), expected,
                    check_dtype=False, check_exact=False, atol=1e-10, rtol=1e-10,
                )
        print(f"PASS {path.name}: {len(result)} output rows")

    audit = outputs["14"].iloc[0]
    expected_nonzero = {
        "total_records": 45211,
        "unknown_contact_methods": 13020,
        "unknown_previous_outcomes": 36959,
        "unknown_previous_outcomes_with_zero_contacts": 36954,
    }
    for field, value in audit.items():
        if value != expected_nonzero.get(field, 0):
            raise ValueError(f"Unexpected data-quality result: {field}={value}")

    # Exercise added guards with synthetic input, separately from historical results.
    connection.execute("CREATE TABLE guard_raw AS SELECT * FROM raw LIMIT 0")
    connection.execute("""INSERT INTO guard_raw (housing, loan, poutcome, previous, campaign)
        VALUES (NULL, FALSE, 'unknown', 0, NULL),
               (NULL, TRUE, 'unknown', 0, 0),
               (FALSE, FALSE, 'unknown', 0, 5)""")
    for number in ("08", "11"):
        path = next((ROOT / "sql").glob(f"{number}_*.sql"))
        query = path.read_text()
        for published, local in [("bank_campaigns_raw", "guard_raw"),
                                 ("crm_priority_segments_v1", "guard_v1"),
                                 ("crm_priority_segments_v2", "guard_v2")]:
            query = query.replace(f"`bank-marketing-crm.bank_marketing_crm.{published}`", f"`{local}`")
        connection.execute(sqlglot.transpile(query, read="bigquery", write="duckdb")[0])
    guards = connection.execute("SELECT lead_segment_v2 FROM guard_v2 ORDER BY previous, campaign NULLS FIRST").fetchall()
    if guards != [("Limited - Unknown loan status",), ("Limited - Has loan",), ("Limited - No loans",)]:
        raise ValueError(f"Loan guard mismatch: {guards}")
    path = next((ROOT / "sql").glob("05_*.sql"))
    query = path.read_text().replace("`bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`", "`guard_raw`")
    groups = connection.execute(sqlglot.transpile(query, read="bigquery", write="duckdb")[0]).fetchdf()
    if dict(zip(groups.contact_frequency, groups.total_records)) != {"Unknown": 2, "5+ contacts": 1}:
        raise ValueError("Contact-frequency guard mismatch")
    print("PASS missing-loan and invalid-contact guards")

    for path in ROOT.rglob("*.md"):
        for link in re.findall(r"!?\[[^\]]*\]\(([^)]+)\)", path.read_text()):
            if not link.startswith(("https:", "http:", "#", "mailto:")):
                if not (path.parent / link.split("#")[0]).exists():
                    raise ValueError(f"Broken relative link: {path.relative_to(ROOT)} -> {link}")
    print("PASS relative Markdown links")

    if args.check_pbix:
        from pbixray import PBIXRay

        model = PBIXRay(str(ROOT / "Bank_Marketing_CRM_Dashboard.pbix"))
        stored = model.get_table("crm_priority_segments_v2")
        computed = connection.execute("SELECT * FROM v2").fetchdf()
        compare_rows(computed, stored, list(computed.columns))
        measures = {row.Name: row.Expression.strip()
                    for row in model.dax_measures.itertuples()}
        expected_measures = json.loads((ROOT / "verification" / "dax_measures.json").read_text())
        if measures != expected_measures:
            raise ValueError("Stored DAX measures differ from documented definitions")
        group = stored.campaign.map(lambda n: f"{n} contact" if n == 1 else
                                    f"{n} contacts" if n in (2, 3, 4) else
                                    "5+ contacts" if n >= 5 else "Unknown")
        if not group.astype("string").equals(stored["Contact Frequency Group"].astype("string")):
            raise ValueError("Power BI contact-frequency assignments differ")
        print("PASS Power BI source records, segmentation, DAX measures, and frequency groups")
        model.close()
    connection.close()
    print(f"Source SHA-256: {checksum}")
    print("Local checks passed. BigQuery execution and Desktop refresh remain untested.")


if __name__ == "__main__":
    main()
