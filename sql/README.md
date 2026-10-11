# SQL analyses and CRM views

This folder contains **15 BigQuery SQL scripts** reconstructed from the analyses developed during this project. They have been organized and lightly annotated for GitHub; they were **not exported verbatim from saved BigQuery queries**. Compare with your saved queries before describing them as exact execution exports.

## How to run

1. Download the historical [UCI Bank Marketing dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing), and locate `bank-full.csv` inside `bank.zip`. Do not use `bank.csv` or `bank-additional-full.csv`.
2. Replace project `bank-marketing-crm` and dataset `bank_marketing_crm` throughout the SQL files with your own project ID and dataset name. Create the dataset and import the source as `bank_campaigns_raw` using the explicit schema below, a semicolon delimiter, one header row to skip, and zero allowed bad records.
3. Run scripts in numerical order. Scripts `01`–`07` query the raw table.
4. Run `08` to create CRM view v1. Scripts `09` and `10` query v1.
5. Run `11` to create CRM view v2. Scripts `12`–`15` query v2.

## Explicit import schema

Use these column names and types in CSV order:

```text
age:INTEGER
job:STRING
marital:STRING
education:STRING
default:BOOLEAN
balance:INTEGER
housing:BOOLEAN
loan:BOOLEAN
contact:STRING
day:INTEGER
month:STRING
duration:INTEGER
campaign:INTEGER
pdays:INTEGER
previous:INTEGER
poutcome:STRING
y:BOOLEAN
```

BigQuery accepts source `yes`/`no` values as BOOLEAN; see [Google's CSV loading documentation](https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-csv#data_types). Schema autodetection was used during initial development; an explicit schema is supplied here for repeatable setup.

Expected script 01 baseline: **45,211 records**, **5,289 subscriptions**, and **11.70% conversion**. Rates are calculated from unrounded counts, then rounded for display.

## Published outputs and verification

[Historical result CSVs](../results/) are independently recomputed using the published SQL translated into DuckDB, not native BigQuery job exports. See [verification instructions](../verification/README.md) for the repeatable local check and source checksum.

Script 14 checks source categories, NULLs, valid contact-count ranges, and the 36,954 unknown-outcome records with zero previous contacts. View v2 separates unavailable loan status from a confirmed housing/personal loan; the historical source has no unavailable loan statuses.

`CREATE OR REPLACE VIEW` will replace existing views in the named Google Cloud project. Change the project ID before running in another environment.

## Methodological cautions

- Unit of analysis is **campaign records**, not necessarily unique customers.
- Rules were developed after looking at all records and subscription outcomes, so descriptive lift must **not** be presented as independently validated predictive lift or sales increase.
- Script 15 uses a new random 50/50 split each run; it checks descriptive stability in the original data, not generalization to future campaigns.
- `unknown` is a recorded categorical value, not SQL `NULL`. Most unknown previous outcomes correspond to no earlier recorded contacts.
- Observed contact method/frequency and loan associations are not causal. Loan-based prioritization would require legal, suitability, fairness, and prospective validation review before real-world use.
