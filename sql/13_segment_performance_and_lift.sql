-- Conversion lift is a ratio against overall historical conversion rate.
-- It is NOT a causal sales improvement or externally validated prediction metric.
WITH segment_summary AS (
  SELECT
    lead_segment_v2 AS crm_segment,
    COUNT(*) AS total_records,
    COUNTIF(y = TRUE) AS subscriptions
  FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v2`
  GROUP BY lead_segment_v2
)
SELECT
  crm_segment,
  total_records,
  subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(subscriptions, total_records), 2) AS conversion_rate_percent,
  ROUND(100.0 * SAFE_DIVIDE(total_records, SUM(total_records) OVER()), 2)
    AS share_of_records_percent,
  ROUND(100.0 * SAFE_DIVIDE(subscriptions, SUM(subscriptions) OVER()), 2)
    AS share_of_subscriptions_percent,
  ROUND(
    SAFE_DIVIDE(
      SAFE_DIVIDE(subscriptions, total_records),
      SAFE_DIVIDE(SUM(subscriptions) OVER(), SUM(total_records) OVER())
    ), 2
  ) AS conversion_lift
FROM segment_summary
ORDER BY conversion_rate_percent DESC;
