-- Very small 'unknown' prior-outcome groups should not be overinterpreted.
SELECT
  poutcome AS previous_campaign_outcome,
  CASE
    WHEN previous = 0 THEN '0 contacts'
    WHEN previous = 1 THEN '1 contact'
    WHEN previous BETWEEN 2 AND 3 THEN '2-3 contacts'
    ELSE '4+ contacts'
  END AS previous_contact_group,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`
GROUP BY previous_campaign_outcome, previous_contact_group
ORDER BY previous_campaign_outcome, previous_contact_group;
