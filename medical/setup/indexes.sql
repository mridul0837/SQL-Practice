-- Speeds up joins on the big SynPUF tables. Safe to re-run.
USE MedicalPractice;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ix_bene_id')
    CREATE INDEX ix_bene_id ON synpuf.beneficiary_2008 (DESYNPUF_ID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ix_inpt_id')
    CREATE INDEX ix_inpt_id ON synpuf.inpatient_claims (DESYNPUF_ID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ix_outpt_id')
    CREATE INDEX ix_outpt_id ON synpuf.outpatient_claims (DESYNPUF_ID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ix_pde_id')
    CREATE INDEX ix_pde_id ON synpuf.prescription_drug_events (DESYNPUF_ID);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ix_mimic_adm_subject')
    CREATE INDEX ix_mimic_adm_subject ON mimic.admissions (subject_id, hadm_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ix_mimic_lab_item')
    CREATE INDEX ix_mimic_lab_item ON mimic.labevents (itemid);
GO
