-- Exploration of loan fields within the 'Limited history' CRM segment.
-- NOT an approved loan suitability or customer eligibility rule.
SELECT
  housing AS has_housing_loan,
  loan AS has_personal_loan,
  COUNT(*) AS total_records,
  COUNTIF(y = TRUE) AS subscriptions,
  ROUND(100.0 * SAFE_DIVIDE(COUNTIF(y = TRUE), COUNT(*)), 2) AS conversion_rate_percent
FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v1`
WHERE lead_priority = 'Limited history'
GROUP BY housing, loan
ORDER BY conversion_rate_percent DESC;
