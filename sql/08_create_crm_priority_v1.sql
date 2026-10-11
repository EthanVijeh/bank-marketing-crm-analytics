-- Rule-based CRM segmentation prototype, version 1.
-- Rules were selected after exploring the full dataset: NOT a validated model.
CREATE OR REPLACE VIEW `bank-marketing-crm.bank_marketing_crm.crm_priority_segments_v1` AS
SELECT
  *,
  CASE
    WHEN poutcome = 'success' THEN 'High'
    WHEN poutcome = 'other'
      OR (poutcome = 'failure' AND previous >= 2) THEN 'Medium'
    WHEN poutcome = 'failure' THEN 'Standard'
    ELSE 'Limited history'
  END AS lead_priority
FROM `bank-marketing-crm.bank_marketing_crm.bank_campaigns_raw`;
