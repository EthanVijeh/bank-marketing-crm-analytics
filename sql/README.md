# SQL analyses and CRM views

This folder contains **15 BigQuery SQL scripts** reconstructed from the analyses developed during this project. They have been organized and lightly annotated for GitHub; they were **not exported verbatim from saved BigQuery queries**. Compare with your saved queries before describing them as exact execution exports.

## How to run

1. Download the historical [UCI Bank Marketing dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing), and upload `bank-full.csv` to `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`, using a semicolon delimiter and skipping the header row. BigQuery auto-detected `y`, `housing`, and `loan` as BOOLEAN in this project.
2. Scripts `01`–`07` run against that raw table.
3. Run `08` to create CRM view v1. Scripts `09` and `10` query v1.
4. Run `11` to create CRM view v2. Scripts `12`–`15` query v2.

`CREATE OR REPLACE VIEW` will replace existing views in the named Google Cloud project. Change the project ID before running in another environment.

## Methodological cautions

- Unit of analysis is **campaign records**, not necessarily unique customers.
- Rules were developed after looking at all records and subscription outcomes, so descriptive lift must **not** be presented as independently validated predictive lift or sales increase.
- Script 15 uses a new random 50/50 split each run; it checks descriptive stability in the original data, not generalization to future campaigns.
- `unknown` is a recorded categorical value, not SQL `NULL`. Most unknown previous outcomes correspond to no earlier recorded contacts.
- Observed contact method/frequency and loan associations are not causal. Loan-based prioritization would require legal, suitability, fairness, and prospective validation review before real-world use.
