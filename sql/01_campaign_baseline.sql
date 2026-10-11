-- Baseline KPI: campaign-record subscription rate (y is BOOLEAN).
SELECT
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS successful_subscriptions,
  COUNTIF(y = FALSE) AS unsuccessful_records,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`;
