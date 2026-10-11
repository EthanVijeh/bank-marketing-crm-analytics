-- Exploratory sample stability check, not an independent validation.
-- RAND() makes the exact results change with every execution.
WITH randomized AS (
  SELECT
    lead_segment_v2,
    y,
    IF(RAND() < 0.5, 'Sample A', 'Sample B') AS sample_group
  FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v2`
)
SELECT
  sample_group,
  lead_segment_v2,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2)
    AS conversion_rate_percent
FROM randomized
GROUP BY sample_group, lead_segment_v2
ORDER BY lead_segment_v2, sample_group;
