-- Step 4: check the build. Compare RowsLoaded with Expected; every row should say OK.
USE MedicalPractice;
GO
SELECT x.TableName, x.Expected, c.RowsLoaded,
       CASE WHEN c.RowsLoaded = x.Expected THEN 'OK' ELSE 'CHECK' END AS Result
FROM (VALUES
 ('mimic.admissions', 275)
,('mimic.d_icd_diagnoses', 109775)
,('mimic.d_icd_procedures', 85257)
,('mimic.d_labitems', 1622)
,('mimic.diagnoses_icd', 4506)
,('mimic.icustays', 140)
,('mimic.labevents', 107727)
,('mimic.patients', 100)
,('mimic.prescriptions', 18087)
,('mimic.procedures_icd', 722)
,('mimic.services', 319)
,('mimic.transfers', 1190)
,('partd.geo_drug', 117661)
,('synpuf.beneficiary_2008', 116352)
,('synpuf.inpatient_claims', 66773)
,('synpuf.outpatient_claims', 790790)
,('synpuf.prescription_drug_events', 5552421)
) AS x(TableName, Expected)
LEFT JOIN (
    SELECT s.name + '.' + t.name AS TableName, SUM(p.rows) AS RowsLoaded
    FROM sys.tables t
    JOIN sys.schemas s    ON s.schema_id = t.schema_id
    JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
    GROUP BY s.name, t.name
) AS c ON c.TableName = x.TableName
ORDER BY x.TableName;
GO

-- Values that did not convert: text was present but TRY_CONVERT returned NULL.
-- Example for one table. Repeat the pattern for any typed column you want to check.
SELECT COUNT(*) AS BadDates
FROM stg.mimic_patients
WHERE NULLIF(dod, '') IS NOT NULL AND TRY_CONVERT(date, NULLIF(dod, '')) IS NULL;   -- expect 0
GO

-- When every check is OK, remove the staging tables:
-- DROP TABLE stg.mimic_patients, ...   (or run the generated block below)
DECLARE @sql nvarchar(max) = '';
SELECT @sql += 'DROP TABLE stg.' + name + ';' FROM sys.tables WHERE schema_id = SCHEMA_ID('stg');
EXEC (@sql);
DROP SCHEMA stg;
GO
