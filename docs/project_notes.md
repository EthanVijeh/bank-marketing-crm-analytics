# Bank Marketing and CRM Optimization — working notes

## Purpose

Analyze historical marketing-contact records for a Portuguese bank and construct a reproducible, exploratory CRM segmentation prototype. This is a **portfolio demonstration**, not a deployed CRM or independently validated lead-scoring model.

## Source and tooling

- Source: [UCI Bank Marketing dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing), full historical version (`bank-full.csv`).
- Tools used during the project: Google BigQuery SQL and Power BI Desktop (DAX measures and visuals).
- Unit of analysis: campaign **record**, not confirmed unique customer.

## Verified results from working queries

| Metric | Result |
|---|---:|
| Total records | 45,211 |
| Recorded subscriptions | 5,289 |
| Overall conversion | 11.70% |
| High segment size | 1,511 |
| High segment subscriptions | 978 |
| High segment observed conversion | 64.73% |
| High segment observed lift vs overall | 5.53x |
| Contact method marked `unknown` | 13,020 |
| Previous campaign outcome marked `unknown` | 36,959 |
| NULL subscription outcomes | 0 |
| NULL CRM segments (v2) | 0 |
| NULL housing/personal-loan statuses | 0 |

## Exploratory recommendations

1. Test whether previous campaign engagement can help a sales manager prioritize follow-up, using **new** prospectively collected campaigns to evaluate accuracy and business impact.
2. Investigate campaign contact-frequency patterns and test alternative outreach strategies. Do **not** interpret historical conversion differences as effects of extra calls.
3. Improve the capture and interpretation of contact-method information, clearly distinguishing unrecorded values from inapplicable fields.

## Important limitations

The segmentation rules were selected after examining the original full dataset, and were then scored on that same data. The later random split was performed **after** rule development. It shows descriptive stability but is **not** unbiased held-out validation. No causal uplift, future predictive accuracy, or actual return on investment has been established. Loan-based exploratory segmentation is especially sensitive and should not be deployed without separate fairness, suitability, legal, and prospective validation review. Many previous campaign outcomes are `unknown` because there were zero earlier contacts. The dataset is historical, geographically specific, and lacks unique customer IDs.

These notes should be refined and cross-checked against the final report before publishing as definitive business recommendations.
