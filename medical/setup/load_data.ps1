# Loads the downloaded public medical datasets into a local SQL Server database
# called MedicalPractice (one schema per dataset: mimic, synpuf, partd).
#
# Run from PowerShell:   .\medical\setup\load_data.ps1
# Needs: the files in D:\sql-practice\_downloads (see medical\setup\manual\MANUAL.md for where they come from)
# Auth:  Windows authentication only. No passwords.

$ErrorActionPreference = 'Stop'
$root = 'd:\sql-practice\_downloads'
$mimic = "$root\mimic-iv-demo"
$syn = "$root\de-synpuf"
$partd = "$root\partd"

Add-Type -ReferencedAssemblies System.Data, System.Xml -TypeDefinition @'
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Collections.Generic;

public static class CsvLoader {
    // Reads one CSV record (handles quoted fields, "" escapes and newlines inside quotes).
    static List<string> ReadRecord(StreamReader r) {
        var f = new List<string>(); var sb = new StringBuilder(); bool q = false, any = false;
        int c;
        while ((c = r.Read()) != -1) {
            any = true; char ch = (char)c;
            if (q) {
                if (ch == '"') { if (r.Peek() == '"') { r.Read(); sb.Append('"'); } else q = false; }
                else sb.Append(ch);
            } else if (ch == '"') q = true;
            else if (ch == ',') { f.Add(sb.ToString()); sb.Length = 0; }
            else if (ch == '\n') { f.Add(sb.ToString()); return f; }
            else if (ch == '\r') { }
            else sb.Append(ch);
        }
        if (!any) return null;
        f.Add(sb.ToString()); return f;
    }

    public static void Load(string connStr, string path, string stagingName, int ncols) {
        using (var cn = new SqlConnection(connStr)) {
            cn.Open();
            using (var bc = new SqlBulkCopy(cn, SqlBulkCopyOptions.TableLock, null)) {
                bc.DestinationTableName = "stg.[" + stagingName + "]";
                bc.BulkCopyTimeout = 0; bc.BatchSize = 50000;
                var dt = new DataTable();
                for (int i = 0; i < ncols; i++) dt.Columns.Add("c" + i, typeof(string));
                for (int i = 0; i < ncols; i++) bc.ColumnMappings.Add(i, i);
                using (var r = new StreamReader(path, new UTF8Encoding(false), true)) {
                    ReadRecord(r); // header
                    List<string> rec;
                    while ((rec = ReadRecord(r)) != null) {
                        if (rec.Count == 1 && rec[0] == "") continue;
                        var row = dt.NewRow();
                        for (int i = 0; i < ncols; i++) row[i] = i < rec.Count ? (object)rec[i] : DBNull.Value;
                        dt.Rows.Add(row);
                        if (dt.Rows.Count >= 50000) { bc.WriteToServer(dt); dt.Clear(); }
                    }
                    if (dt.Rows.Count > 0) bc.WriteToServer(dt);
                }
            }
        }
    }
}
'@

function Invoke-Sql([string]$db, [string]$sql, [switch]$scalar) {
    $cn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost;Database=$db;Integrated Security=True;TrustServerCertificate=True")
    $cn.Open()
    $cmd = $cn.CreateCommand(); $cmd.CommandText = $sql; $cmd.CommandTimeout = 0
    if ($scalar) { $r = $cmd.ExecuteScalar() } else { [void]$cmd.ExecuteNonQuery(); $r = $null }
    $cn.Close(); return $r
}

# Type rules: return a SQL type for a column, or $null for the default text type.
$mimicType = {
    param($c)
    # text-valued "id" columns (e.g. provider ids like P03YMR, poe_id like 123-1) stay text
    if ($c -match 'provider_id$|^poe_id$|^anchor_year_group$') { return $null }
    if ($c -match '(^|_)id$|^itemid$|^seq_num$|^anchor_|^icd_version$|^hospital_expire_flag$|^poe_seq$') { return 'BIGINT' }
    if ($c -match 'time$') { return 'DATETIME2(0)' }
    if ($c -in 'chartdate', 'dod') { return 'DATE' }
    if ($c -in 'valuenum', 'ref_range_lower', 'ref_range_upper', 'los') { return 'FLOAT' }
    if ($c -in 'comments') { return 'NVARCHAR(MAX)' }
    return $null
}
$synType = {
    param($c)
    if ($c -match '_DT$') { return 'DATE' }
    if ($c -eq 'QTY_DSPNSD_NUM') { return 'DECIMAL(12,3)' }
    if ($c -match '_AMT$|^MEDREIMB_|^BENRES_|^PPPYMT_|_CHRG|_PMT') { return 'DECIMAL(14,2)' }
    if ($c -match '^SP_(?!STATE)|_MONS$|^PLAN_CVRG_MOS_NUM$|^DAYS_SUPLY_NUM$|_DAY_CNT$|^BENE_SEX_IDENT_CD$|^BENE_RACE_CD$') { return 'INT' }
    return $null
}
$partdType = {
    param($c)
    if ($c -match '^(GE65_)?Tot_|_Cst_Shr$') { return 'DECIMAL(18,2)' }
    return $null
}

function Load-Table($csv, $schema, $table, $typeRule, $defaultText) {
    $header = (Get-Content -LiteralPath $csv -TotalCount 1) -replace [char]0xFEFF, ''
    $cols = $header -split ',' | ForEach-Object { $_.Trim('"') }
    $stg = "[stg].[$($schema)_$table]"; $fin = "[$schema].[$table]"

    Invoke-Sql 'MedicalPractice' "IF OBJECT_ID('$stg') IS NOT NULL DROP TABLE $stg; IF OBJECT_ID('$fin') IS NOT NULL DROP TABLE $fin;"
    $stgDef = ($cols | ForEach-Object { "[$_] NVARCHAR(MAX) NULL" }) -join ', '
    Invoke-Sql 'MedicalPractice' "CREATE TABLE $stg ($stgDef);"

    $sw = [Diagnostics.Stopwatch]::StartNew()
    # Client-side load: this script reads the file itself and sends the rows to the server.
    [CsvLoader]::Load("Server=localhost;Database=MedicalPractice;Integrated Security=True;TrustServerCertificate=True", $csv, "$($schema)_$table", $cols.Count)

    $defs = @(); $sel = @(); $checks = @()
    foreach ($c in $cols) {
        $t = & $typeRule $c
        if (-not $t) { $t = $defaultText }
        $defs += "[$c] $t NULL"
        if ($t -like 'NVARCHAR*' -or $t -like 'VARCHAR*') {
            $sel += "NULLIF([$c], '')"
        } else {
            $sel += "TRY_CONVERT($t, NULLIF([$c], ''))"
            $checks += "SUM(CASE WHEN NULLIF([$c], '') IS NOT NULL AND TRY_CONVERT($t, NULLIF([$c], '')) IS NULL THEN 1 ELSE 0 END) AS [$c]"
        }
    }
    Invoke-Sql 'MedicalPractice' "CREATE TABLE $fin ($($defs -join ', '));"
    Invoke-Sql 'MedicalPractice' "INSERT INTO $fin SELECT $($sel -join ', ') FROM $stg;"

    $n = Invoke-Sql 'MedicalPractice' "SELECT COUNT_BIG(*) FROM $fin;" -scalar
    $bad = 0
    if ($checks.Count -gt 0) {
        $cn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost;Database=MedicalPractice;Integrated Security=True;TrustServerCertificate=True")
        $cn.Open(); $cmd = $cn.CreateCommand(); $cmd.CommandTimeout = 0
        $cmd.CommandText = "SELECT $($checks -join ', ') FROM $stg;"
        $rd = $cmd.ExecuteReader(); [void]$rd.Read()
        for ($i = 0; $i -lt $rd.FieldCount; $i++) { if (-not $rd.IsDBNull($i) -and $rd.GetInt32($i) -gt 0) { $bad += $rd.GetInt32($i); Write-Warning "  $table.$($rd.GetName($i)): $($rd.GetInt32($i)) values did not convert" } }
        $rd.Close(); $cn.Close()
    }
    Invoke-Sql 'MedicalPractice' "DROP TABLE $stg;"
    '{0,-8} {1,-28} {2,10:N0} rows  {3,6:N1}s  unconverted={4}' -f $schema, $table, $n, $sw.Elapsed.TotalSeconds, $bad
}

# --- database and schemas ---
Invoke-Sql 'master' "IF DB_ID('MedicalPractice') IS NULL CREATE DATABASE MedicalPractice;"
foreach ($s in 'stg', 'mimic', 'synpuf', 'partd') {
    Invoke-Sql 'MedicalPractice' "IF SCHEMA_ID('$s') IS NULL EXEC('CREATE SCHEMA $s');"
}

# --- MIMIC-IV demo ---
foreach ($t in 'patients', 'admissions', 'diagnoses_icd', 'd_icd_diagnoses', 'prescriptions', 'labevents', 'd_labitems', 'procedures_icd', 'd_icd_procedures', 'transfers', 'services') {
    Load-Table "$mimic\hosp\$t.csv" 'mimic' $t $mimicType 'NVARCHAR(500)'
}
Load-Table "$mimic\icu\icustays.csv" 'mimic' 'icustays' $mimicType 'NVARCHAR(500)'

# --- DE-SynPUF sample 1 ---
Load-Table "$syn\DE1_0_2008_Beneficiary_Summary_File_Sample_1.csv" 'synpuf' 'beneficiary_2008' $synType 'VARCHAR(50)'
Load-Table "$syn\DE1_0_2008_to_2010_Inpatient_Claims_Sample_1.csv" 'synpuf' 'inpatient_claims' $synType 'VARCHAR(50)'
Load-Table "$syn\DE1_0_2008_to_2010_Outpatient_Claims_Sample_1.csv" 'synpuf' 'outpatient_claims' $synType 'VARCHAR(50)'
Load-Table "$syn\DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_1.csv" 'synpuf' 'prescription_drug_events' $synType 'VARCHAR(50)'

# --- Medicare Part D (by geography and drug) ---
Load-Table "$partd\partd_geo_drug.csv" 'partd' 'geo_drug' $partdType 'NVARCHAR(200)'

Invoke-Sql 'MedicalPractice' "DROP SCHEMA IF EXISTS stg;"
Write-Host 'Done.'
