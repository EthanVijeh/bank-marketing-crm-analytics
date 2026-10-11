-- 'campaign' counts contacts during the current campaign, including final contact.
-- The association here does not establish the effect of making more calls.
SELECT
  CASE
    WHEN campaign = 1 THEN '1 contact'
    WHEN campaign = 2 THEN '2 contacts'
    WHEN campaign = 3 THEN '3 contacts'
    WHEN campaign = 4 THEN '4 contacts'
    ELSE '5+ contacts'
  END AS contact_frequency,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`
GROUP BY contact_frequency
ORDER BY MIN(campaign);
