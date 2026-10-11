-- Literal 'unknown' category is different from SQL NULL.
SELECT
  COUNT(*) AS total_records,
  COUNTIF(y IS NULL) AS missing_subscription_outcomes,
  COUNTIF(lead_segment_v2 IS NULL) AS missing_crm_segments,
  COUNTIF(contact = 'unknown') AS unknown_contact_methods,
  COUNTIF(poutcome = 'unknown') AS unknown_previous_outcomes,
  COUNTIF(housing IS NULL OR loan IS NULL) AS missing_loan_information,
  COUNTIF(poutcome = 'unknown' AND previous = 0)
    AS unknown_previous_outcomes_with_zero_contacts,
  COUNTIF(contact IS NULL) AS null_contact_methods,
  COUNTIF(poutcome IS NULL) AS null_previous_outcomes,
  COUNTIF(contact NOT IN ('cellular', 'telephone', 'unknown'))
    AS unexpected_contact_categories,
  COUNTIF(poutcome NOT IN ('success', 'failure', 'other', 'unknown'))
    AS unexpected_previous_outcome_categories,
  COUNTIF(campaign IS NULL OR campaign < 1) AS invalid_current_contact_counts,
  COUNTIF(previous IS NULL OR previous < 0) AS invalid_previous_contact_counts,
  COUNTIF(lead_segment_v2 = 'Limited - Unknown loan status')
    AS limited_history_unknown_loan_status
FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v2`;
