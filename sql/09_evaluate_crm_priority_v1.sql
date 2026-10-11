-- Descriptive performance for CRM segmentation version 1.
SELECT
  lead_priority,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v1`
GROUP BY lead_priority
ORDER BY conversion_rate_percent DESC;
