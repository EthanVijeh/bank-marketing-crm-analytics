-- Descriptive conversion rates for CRM segmentation version 2.
SELECT
  lead_segment_v2,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v2`
GROUP BY lead_segment_v2
ORDER BY conversion_rate_percent DESC;
