# Historical result evidence

These CSVs are **independent local recomputations**, not exports of the project's original BigQuery jobs.

| Provenance | Value |
|---|---|
| Verification date | October 11, 2026 |
| Source | UCI Bank Marketing archive, nested `bank.zip` → `bank-full.csv` |
| Source rows | 45,211 |
| CSV SHA-256 | `d1513ec63b385506f7cfce9f2c5caa9fe99e7ba4e8c3fa264b3aaf0f849ed32d` |
| Original audited repository commit | `bf08c131fb1777bee47ab0bb476c478dfb2b026e` |
| Queries used | Published SQL files in the same repository revision as these CSVs, including the audit guard fixes |
| Execution | SQLGlot BigQuery-to-DuckDB translation, then local DuckDB execution |
| Dependencies | [Pinned verification requirements](../verification/requirements.txt) |

The original audited commit identifies the starting snapshot; it is not the revision of every query used here. Use the Git history of these result files to identify their corresponding SQL revision.

CSV names correspond to scripts in [sql/](../sql/). Scripts 08 and 11 create views and have no analytical result CSV. Script 15 uses a changing random split; its output is not retained as evidence of stability.

The [verification script](../verification/README.md) recomputes and compares these outputs and checks the saved PBIX model against the source and segmentation rules.

Interpret conversion lift as a segment's historical conversion rate divided by the overall historical conversion rate. It is not an implemented sales increase. Verification of arithmetic does not independently validate predictive performance.

## Headline calculations

- Overall conversion: `5,289 / 45,211 × 100 = 11.70%` after rounding.
- High conversion: `978 / 1,511 × 100 = 64.73%` after rounding.
- High historical lift: `(978 / 1,511) / (5,289 / 45,211) = 5.53×` after rounding.
- High share of records: `1,511 / 45,211 × 100 = 3.34%` after rounding.
- High share of subscriptions: `978 / 5,289 × 100 = 18.49%` after rounding.

Original data credit: Moro, S., Rita, P., & Cortez, P. (2014). *Bank Marketing* [Dataset]. [UCI Machine Learning Repository](https://doi.org/10.24432/C5K306), CC BY 4.0. The CSVs here are derived aggregate summaries.
