# Power BI Dashboard

This folder contains documentation for the Power BI report developed as part of the Bank Marketing Analytics & CRM Decision Support project.

**[View the Power BI Dashboard File](../Bank_Marketing_CRM_Dashboard.pbix)**

## Dashboard Pages

### 1. CRM Executive Overview

An interactive dashboard featuring:

- Total campaign records
- Successful term deposit subscriptions
- Overall conversion rate
- Historical conversion rates by CRM segment
- Campaign volume by CRM segment
- Interactive contact-method and previous-campaign-outcome filters

### 2. Campaign Operations

An operational dashboard featuring:

- Conversion rate by campaign contact frequency
- Campaign volume by contact frequency
- Conversion rate by contact method
- Campaign record volume by contact method

## Technologies

- Microsoft Power BI Desktop
- DAX calculations and measures
- Google BigQuery data source

## Opening the Dashboard

Download the `.pbix` file linked above and open it in Microsoft Power BI Desktop.

The file contains an imported historical dataset. Its saved Power Query navigation references project `bank-marketing-crm`, dataset `bank_marketing_crm`, and view `crm_priority_segments_v2`.

To refresh in your own environment:

1. Import the source and create the two views using the [SQL setup instructions](../sql/README.md).
2. In Power BI Desktop, open **Transform data** and edit the `crm_priority_segments_v2` query in the Advanced Editor. Replace the saved project and dataset navigation with your own values.
3. Update the project navigation in the separate `bank-marketing-crm` query as well, or disable its load if that navigation table is not needed. It is unconnected and not used by report visuals.
4. Configure your Google credentials for the BigQuery source, apply the changes, and refresh.

Refresh and Desktop interaction have not been tested by the independent local repository verification.

**[View Dashboard Screenshots](../screenshots/)**

**[Return to Main Project README](../README.md)**

## Saved DAX definitions

The following expressions were extracted from the committed PBIX model. All report visuals use `crm_priority_segments_v2`; its `y` field is Boolean.

### Total Records

```dax
Total Records =
COUNTROWS('crm_priority_segments_v2')
```

### Successful Subscriptions

```dax
Successful Subscriptions =
CALCULATE(
    COUNTROWS('crm_priority_segments_v2'),
    'crm_priority_segments_v2'[y] = TRUE()
)
```

### Conversion Rate

```dax
Conversion Rate =
DIVIDE(
    [Successful Subscriptions],
    [Total Records],
    0
)
```

`Conversion Rate` is formatted as a percentage. The measures use the current filter context; the saved definition returns 0 when its denominator is zero.

### Contact Frequency Group

```dax
Contact Frequency Group =
SWITCH(
    TRUE(),
    'crm_priority_segments_v2'[campaign] = 1, "1 contact",
    'crm_priority_segments_v2'[campaign] = 2, "2 contacts",
    'crm_priority_segments_v2'[campaign] = 3, "3 contacts",
    'crm_priority_segments_v2'[campaign] = 4, "4 contacts",
    'crm_priority_segments_v2'[campaign] >= 5, "5+ contacts",
    "Unknown"
)
```

## Saved report verification

Independent extraction found 45,211 stored campaign records, matching the UCI source across all 17 original columns without relying on row order. Both stored segmentation fields match the published rules for this source. See [result provenance](../results/README.md) and [verification instructions](../verification/README.md).

The saved report has two pages: `Page 1` (the executive overview described above) and `Campaign Operations`. The saved file and screenshots have not been visually reformatted during this audit.

## Remaining Power BI Desktop presentation checklist

- Rename `Page 1` to `CRM Executive Overview`.
- Use consistent chart-title sizes on the executive page.
- Increase operations-page data-label size and contrast; export a higher-resolution screenshot.
- Use comma-separated card counts and a consistent chart count convention.
- Sort both contact-frequency charts by a numeric 1–5 group order, rather than conversion rate, so filtering does not reorder the sequence. Add a sort column in Desktop if needed.
- Add this footer to both pages: `Historical campaign records • Exploratory analysis • Associations are not causal`.
- Save the PBIX, test slicers and refresh in Desktop, and export both screenshots from that same saved version.

These are pending presentation tasks, not completed changes or defects in the historical arithmetic.
