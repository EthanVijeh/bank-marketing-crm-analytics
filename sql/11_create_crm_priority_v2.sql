-- Rule-based CRM segmentation prototype, version 2.
-- Explores loan status among limited-history records; not a real bank decision rule.
CREATE OR REPLACE VIEW `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v2` AS
SELECT
  *,
  CASE
    WHEN lead_priority = 'Limited history'
      AND housing = FALSE AND loan = FALSE THEN 'Limited - No loans'
    WHEN lead_priority = 'Limited history' THEN 'Limited - Has loan'
    ELSE lead_priority
  END AS lead_segment_v2
FROM `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v1`;
