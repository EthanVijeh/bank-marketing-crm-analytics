# Bank Marketing Analytics & CRM Decision Support

**SQL | Google BigQuery | Power BI | Business Intelligence | CRM Segmentation**

An end-to-end business analytics project analyzing **45,211 historical banking campaign records** to evaluate marketing performance, identify customer engagement patterns, and develop a rule-based CRM segmentation system.

The project combines SQL analysis, business intelligence dashboards, and data-driven recommendations to demonstrate how management information systems can support business decision-making.

> **Project scope:** This is an exploratory business analytics and CRM decision-support project—not a deployed banking system or an independently validated predictive model.

---

## Project Overview

A Portuguese banking institution conducted direct marketing campaigns to promote term deposit subscriptions.

The goal of this project was to analyze historical campaign performance and investigate how customer information and previous interactions could support more informed marketing decisions.

**Key business questions:**

1. Which contact methods are associated with higher subscription rates?
2. How does contact frequency relate to campaign success?
3. Do previous campaign outcomes help identify promising customer segments?
4. Can a rule-based CRM system distinguish groups with different historical conversion rates?
5. How can these findings be presented to management through interactive dashboards?

**Data source:** [UCI Machine Learning Repository — Bank Marketing Dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing)

**Dataset:** `bank-full.csv` — 45,211 campaign records.

---

## Technologies & Skills

| Technology | Application |
|---|---|
| Google BigQuery | Data storage, SQL analysis, and reusable database views |
| SQL | Data aggregation, conditional logic, segmentation, CTEs, and window functions |
| Power BI Desktop | Interactive business intelligence reporting and dashboard development |
| DAX | Custom KPI measures and calculated columns |
| GitHub | Project documentation, version control, and technical portfolio presentation |

**SQL techniques demonstrated:** `SELECT`, `COUNTIF`, `CASE`, `GROUP BY`, `ORDER BY`, `SAFE_DIVIDE`, common table expressions, window functions, and `CREATE OR REPLACE VIEW`.

---

## Power BI Dashboards

Developed a two-page interactive Power BI report to communicate campaign performance and CRM segmentation findings.

### Dashboard 1 — CRM Executive Overview

![CRM Executive Overview](screenshots/crm-executive-overview.png)

The executive dashboard provides an overview of historical marketing performance and CRM segmentation.

**Key features:**
- Total campaign records, successful subscriptions, and overall conversion rate.
- Historical conversion rates across five CRM segments.
- Campaign record volume by CRM segment.
- Interactive filters for contact method and previous campaign outcome.
- Dynamic KPI measures that respond to selected filters.

### Dashboard 2 — Campaign Operations

![Campaign Operations](screenshots/campaign-operations.png)

The operations dashboard examines the relationship between sales outreach activity and historical subscription performance.

**Key features:**
- Conversion rate by number of contacts.
- Campaign volume by contact frequency.
- Conversion rate by contact method.
- Contact-method volume comparisons.

**[View the Power BI Dashboard File](Bank_Marketing_CRM_Dashboard.pbix)**

The `.pbix` file can be opened in Microsoft Power BI Desktop. Refreshing its underlying BigQuery data may require configuring a separate Google Cloud connection.

---

## Key Business Findings

### 1. Overall Campaign Performance

| Metric | Result |
|---|---:|
| Total campaign records | 45,211 |
| Successful subscriptions | 5,289 |
| Unsuccessful records | 39,922 |
| Overall conversion rate | **11.70%** |

Approximately 11.70% of campaign records resulted in a successful term deposit subscription.

This serves as the historical baseline for comparing campaign segments.

### 2. Contact Method Performance

| Contact Method | Records | Conversion Rate |
|---|---:|---:|
| Cellular | 29,285 | **14.92%** |
| Telephone | 2,906 | 13.42% |
| Unknown | 13,020 | 4.07% |

**Finding:** Cellular contacts had the highest observed conversion rate.

However, the differences do not prove that one contact method caused higher subscription rates. Customer composition, campaign timing, and other factors may influence the results.

The substantial number of records with an unknown contact method also identifies an area for further data-quality investigation.

### 3. Previous Campaign Outcomes

| Previous Outcome | Records | Conversion Rate |
|---|---:|---:|
| Success | 1,511 | **64.73%** |
| Other | 1,840 | 16.68% |
| Failure | 4,901 | 12.61% |
| Unknown | 36,959 | 9.16% |

**Finding:** Records associated with a previously successful marketing campaign had substantially higher historical conversion rates.

This suggests that previous campaign engagement may be useful information for a future CRM lead-prioritization strategy.

### 4. Contact Frequency Analysis

| Contacts During Campaign | Records | Conversion Rate |
|---|---:|---:|
| 1 | 17,544 | **14.60%** |
| 2 | 12,505 | 11.20% |
| 3 | 5,521 | 11.19% |
| 4 | 3,522 | 9.00% |
| 5+ | 6,119 | 6.41% |

**Finding:** Records involving fewer campaign contacts generally had higher observed conversion rates.

This may help identify opportunities to investigate outreach efficiency. It does not establish that reducing contact attempts would increase conversion rates, because customers who are harder to convert may receive more calls.

---

## CRM Lead Segmentation System

One of the project's primary deliverables was a **rule-based CRM segmentation prototype** developed using Google BigQuery.

The system categorizes historical campaign records using information about previous customer engagement and recorded financial characteristics.

### Version 1 — Previous Campaign History

The first version classified records into four categories:

- **High:** Previous campaign outcome was successful.
- **Medium:** Previous outcome was classified as other, or a failed campaign with at least two previous contacts.
- **Standard:** Previous campaign failed with one earlier contact.
- **Limited History:** No usable previous campaign outcome for the rules.

This version demonstrated meaningful differences in historical conversion rates but placed approximately 81.75% of records in the Limited History category.

### Version 2 — Enhanced Segmentation

To investigate the large Limited History category further, Version 2 incorporated recorded housing-loan and personal-loan information.

This created five exploratory segments.

| CRM Segment | Records | Subscriptions | Conversion Rate | Historical Lift |
|---|---:|---:|---:|---:|
| High | 1,511 | 978 | **64.73%** | 5.53× |
| Medium | 5,034 | 735 | 14.60% | 1.25× |
| Limited – No Loans | 14,365 | 1,926 | 13.41% | 1.15× |
| Standard | 1,707 | 190 | 11.13% | 0.95× |
| Limited – Has Loan | 22,594 | 1,460 | 6.46% | 0.55× |

### Key CRM Finding

The High segment represented approximately **3.34% of campaign records** but accounted for **18.49% of successful subscriptions**.

Its historical conversion rate was 5.53 times the overall average.

These results show that simple CRM rules can organize historical records into segments with substantially different observed conversion rates.

**Important:** Historical lift is the ratio between a segment's conversion rate and the overall conversion rate. It does not represent sales growth caused by implementing the segmentation rules.

Additionally, the segment labels do not form a fully validated priority ranking. For example, Limited – No Loans has a higher observed conversion rate than Standard.

**SQL implementation:**

- [CRM Segmentation — Version 1](sql/08_create_crm_priority_v1.sql)
- [CRM Segmentation — Version 2](sql/11_create_crm_priority_v2.sql)
- [Segmentation Performance and Lift Analysis](sql/13_segment_performance_and_lift.sql)

---

## Data Quality & Evaluation

Performed SQL-based checks to evaluate the completeness of key analytical fields.

| Data Quality Check | Result |
|---|---:|
| Total records | 45,211 |
| Missing subscription outcomes (`NULL`) | 0 |
| Missing CRM segment assignments (`NULL`) | 0 |
| Missing housing/personal-loan information (`NULL`) | 0 |
| Unknown contact methods | 13,020 |
| Unknown previous campaign outcomes | 36,959 |

An important distinction is that `unknown` represents a recorded categorical value rather than an SQL `NULL`.

Of the 36,959 records with an unknown previous campaign outcome, 36,954 had zero previous contacts. Consequently, most of these records represent limited previous campaign history rather than necessarily missing data.

### Preliminary Segmentation Stability Check

The campaign records were randomly divided into two samples to examine whether the five CRM segments exhibited similar historical conversion patterns.

Both samples showed broadly consistent segment-level conversion rates.

However, the segmentation rules had already been developed using the complete dataset.

Therefore, **this exercise is a descriptive stability check, not independent predictive validation**.

The model has not been evaluated on genuinely untouched or prospective campaign data.

**Supporting SQL:**

- [Data Quality Audit](sql/14_data_quality_audit.sql)
- [CRM Stability Check](sql/15_random_split_stability_check.sql)

---

## Business Recommendations

Based on the historical analysis, three potential improvements are proposed for further testing.

### Recommendation 1 — Pilot Engagement-Based Lead Prioritization

Investigate a CRM workflow that considers previous campaign outcomes when reviewing potential leads.

Customers with successful prior campaign histories demonstrated substantially higher observed subscription rates.

A future pilot could evaluate whether engagement-history-based prioritization improves outreach efficiency on new campaign data.

### Recommendation 2 — Review Contact Frequency Strategies

Investigate the relationship between repeated contact attempts, customer engagement, and conversion.

The historical data shows lower conversion rates among records with higher current-campaign contact counts.

A controlled business experiment would be needed to determine whether changes to follow-up practices improve efficiency or customer outcomes.

### Recommendation 3 — Improve Contact Data Documentation

Review CRM procedures for recording contact methods and customer interaction history.

Approximately 28.80% of campaign records had an unknown contact method.

Improved documentation and clearer distinctions between unavailable, inapplicable, and missing values could support future reporting and data analysis.

**These are proposed business actions, not improvements already implemented or proven by the project.**

---

## Project Limitations

The analysis has several important limitations:

1. **Historical dataset:** The records describe historical campaigns at a Portuguese banking institution and may not generalize to modern banking markets.
2. **No unique customer identifiers:** Campaign records cannot be assumed to represent distinct individuals.
3. **No independent predictive validation:** Segmentation rules were developed after examining the complete dataset.
4. **No causal analysis:** Differences in conversion rates do not establish that contact methods, campaign frequency, or loan characteristics caused the outcomes.
5. **No verified financial impact:** Incremental revenue, cost savings, and return on investment were not measured.
6. **Responsible customer segmentation:** Loan-based categories are exploratory and should not be used for real-world outreach decisions without appropriate fairness, legal, customer-suitability, and validation reviews.

The project is intended to demonstrate transparent analytical methods and business decision support rather than claim production-level predictive accuracy.

---

## Repository Structure

| Folder / File | Contents |
|---|---|
| [sql/](sql/) | 15 SQL scripts covering analysis, CRM views, evaluation, and data quality |
| [docs/](docs/) | Project notes, methodology context, and limitations |
| [screenshots/](screenshots/) | Power BI dashboard screenshots |
| [powerbi/](powerbi/) | Power BI project documentation |
| [Bank_Marketing_CRM_Dashboard.pbix](Bank_Marketing_CRM_Dashboard.pbix) | Interactive Power BI Desktop report |
| README.md | Project overview, analytical findings, and documentation |

---

## Reproducing the Project

To reproduce the analysis:

1. Download the [UCI Bank Marketing Dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing) and locate `bank-full.csv` inside `bank.zip`.
2. Create a Google BigQuery project and dataset.
3. Import the CSV into a table named `bank_campaigns_raw`, using a semicolon (`;`) field delimiter, skipping the first header row, and enabling schema autodetection.
4. Confirm the imported data types. In this project, `y`, `housing`, and `loan` were imported as Boolean fields.
5. Run the scripts in the [sql/](sql/) directory, following the order described in [SQL Setup Instructions](sql/README.md).
6. Run the CRM Version 1 creation script before Version 2 and the corresponding evaluation queries.
7. Open the Power BI report in Power BI Desktop, configuring your own BigQuery data source if refreshing the data.

**Reproducibility note:** The SQL files were reconstructed and organized from queries developed during the project rather than exported verbatim from BigQuery's saved-query interface. The scripts should be checked against the original saved queries when exact execution provenance is required.

---

## Data Source & Attribution

Moro, S., Rita, P., & Cortez, P. (2014). *Bank Marketing* [Dataset]. UCI Machine Learning Repository.

**DOI:** https://doi.org/10.24432/C5K306

**Dataset:** https://archive.ics.uci.edu/dataset/222/bank+marketing

The original dataset is made available under a CC BY 4.0 license. Credit for the dataset belongs to its original creators.

---

## Project Summary

This project demonstrates the application of management information systems and business analytics to a real-world banking dataset.

Through SQL analysis, reusable BigQuery views, rule-based CRM segmentation, and interactive Power BI dashboards, the project explores how historical information can support more informed business decisions.

**Core skills demonstrated:** SQL, Google BigQuery, Power BI, DAX, business intelligence, CRM analytics, customer segmentation, data-quality evaluation, and business reporting.
