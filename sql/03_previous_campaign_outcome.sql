-- Previous campaign outcome vs current record-level subscription outcome.
SELECT
  poutcome AS previous_campaign_outcome,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`
GROUP BY poutcome
ORDER BY conversion_rate_percent DESC;
