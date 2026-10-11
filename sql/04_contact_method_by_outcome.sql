-- Compare contact methods within a shared previous-outcome category.
SELECT
  poutcome AS previous_outcome,
  contact AS contact_method,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`
GROUP BY poutcome, contact
ORDER BY previous_outcome, conversion_rate_percent DESC;
