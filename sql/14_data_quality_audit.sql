-- Literal 'unknown' category is different from SQL NULL.
SELECT
  COUNT(*) AS total_records,
  COUNTIF(y IS NULL) AS missing_subscription_outcomes,
  COUNTIF(lead_segment_v2 IS NULL) AS missing_crm_segments,
  COUNTIF(contact = 'unknown') AS unknown_contact_methods,
  COUNTIF(poutcome = 'unknown') AS unknown_previous_outcomes,
  COUNTIF(housing IS NULL OR loan IS NULL) AS missing_loan_information
FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v2`;
