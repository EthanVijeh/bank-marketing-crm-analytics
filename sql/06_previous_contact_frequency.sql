-- 'previous' is number of contacts BEFORE the current campaign.
SELECT
  CASE
    WHEN previous = 0 THEN '0 previous contacts'
    WHEN previous = 1 THEN '1 previous contact'
    WHEN previous BETWEEN 2 AND 3 THEN '2-3 previous contacts'
    ELSE '4+ previous contacts'
  END AS previous_contact_group,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`
GROUP BY previous_contact_group
ORDER BY MIN(previous);
