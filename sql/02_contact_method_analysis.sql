-- 'unknown' indicates unavailable/missing contact-method information.
SELECT
  contact AS contact_method,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`
GROUP BY contact
ORDER BY conversion_rate_percent DESC;
