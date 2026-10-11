# Independent local verification

This script checks historical arithmetic and repository consistency. It does not claim native BigQuery execution, Power BI Desktop refresh, independent predictive validation, or causal impact.

## Run

1. Download the [UCI source archive](https://archive.ics.uci.edu/static/public/222/bank+marketing.zip).
2. Install the pinned dependencies from the repository root:

```bash
python -m pip install -r verification/requirements.txt
```

3. Supply the downloaded ZIP, its nested `bank.zip`, or extracted `bank-full.csv`:

```bash
python verification/verify_repository.py /path/to/bank-marketing.zip --check-pbix
```

The default run compares deterministic query results with the committed CSVs. To regenerate those local evidence files deliberately:

```bash
python verification/verify_repository.py /path/to/bank-marketing.zip --check-pbix --export
```

## Checks

- Source CSV SHA-256 and 45,211-record / 5,289-subscription baseline.
- Parsing and local execution of all 15 published BigQuery scripts after SQLGlot translation into DuckDB SQL. The Google Cloud table identifiers are mapped to local tables/views.
- Deterministic outputs versus the published historical CSVs, with tolerance for floating-point arithmetic.
- Data-quality counts and synthetic checks for missing loan status and invalid contact counts.
- Relative Markdown links.
- Optional PBIX inspection: source and segment row multiset equality, extracted DAX measures versus `dax_measures.json`, and contact-frequency column assignments. This comparison ignores row storage order and retains duplicate multiplicity.

Script 15's random output is executed but is neither compared with an expected split nor exported as stability evidence. Hash-based row comparison is a consistency diagnostic, not proof of predictive validity.

## Boundaries

No Google Cloud credentials are used. A local translation run cannot replace a native BigQuery run. PBIX extraction checks saved model contents; it does not launch Desktop, exercise slicers, authenticate a connector, or validate refresh. The saved report has not been reformatted by this verification script.

For original execution provenance, run the published scripts in BigQuery and publish separately labeled exports with execution date, source checksum, and repository commit.
