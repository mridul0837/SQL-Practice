# Build MedicalPractice by hand

You will create the database, load 17 CSV files, convert the text to real dates and numbers,
and check the result. About 30 minutes, most of it waiting for the 5.5 million row table.

The scripts in this folder do the repetitive typing. Run them in order, and **read each one first**:
that is how you learn the method.

| Script | What it does |
| --- | --- |
| `00_create_database.sql` | Creates the database and the schemas `stg`, `mimic`, `synpuf`, `partd` |
| `01_stage_load.sql` | Creates one all-text staging table per CSV and loads it with `BULK INSERT` |
| `02_convert.sql` | Creates the real tables and fills them from staging with `TRY_CONVERT` |
| `03_checks.sql` | Compares row counts, checks for failed conversions, drops staging |
| `../indexes.sql` | Adds indexes so joins on the big tables are fast |

## Why this order (the idea)

1. **Load everything as text first.** A CSV has no data types. If you let a tool guess, it will turn
   an ICD code such as `0010` into the number 10, or fail on one odd value in row 400,000.
   Text accepts everything.
2. **Convert second.** `TRY_CONVERT(date, x)` returns `NULL` instead of an error when `x` is not a date,
   and `NULLIF(x, '')` turns empty text into `NULL`. Afterwards you count the failures and decide what to do.
3. **Check before you trust it.** Row counts must match the file, and failed conversions must be zero.

## Step 1: Get the files

The CSV files are in `D:\sql-practice\_downloads`:

- `mimic-iv-demo\` (from PhysioNet, MIMIC-IV Clinical Database Demo 2.2): `hosp\` and `icu\` folders
- `de-synpuf\` (CMS DE-SynPUF sample 1): 4 CSV files
- `partd\` (Medicare Part D Prescribers by Geography and Drug): `partd_geo_drug.csv`

SQL Server reads them straight from there: BULK INSERT runs inside the SQL Server service, and that service can read
D:\sql-practice\_downloads (checked). If you move the files to a folder the service cannot read, you get an access error,
and you would have to grant the service read access to that folder.

Where they come from:

- MIMIC-IV Clinical Database Demo 2.2: physionet.org/content/mimic-iv-demo (Open Data Commons ODbL licence; credit PhysioNet if you share results)
- CMS DE-SynPUF sample 1 (Medicare Claims Synthetic Public Use Files): cms.gov, fully synthetic
- Medicare Part D Prescribers by Geography and Drug: data.cms.gov

The data files are not included in this repository.

## Step 2: Create the database

Open `00_create_database.sql` in SSMS and press F5.

`CREATE DATABASE` makes `MedicalPractice.mdf` (data) and `MedicalPractice_log.ldf` (log) in SQL Server's
default data folder. Check with `SELECT name, physical_name FROM MedicalPractice.sys.database_files;`.

## Step 3: Load the CSVs as text

Open `01_stage_load.sql`, read the first block, then press F5.

Things to notice in it:

- Every column is `NVARCHAR(MAX)`: text only.
- `FORMAT = 'CSV'` and `FIELDQUOTE = '"'` make SQL Server understand quoted values with commas inside.
- `FIRSTROW = 2` skips the header line.
- `ROWTERMINATOR = '0x0a'` (a line feed) is used for the MIMIC files, and `'0x0d0a'` (carriage return + line feed)
  for the SynPUF and Part D files. The files were made on different systems, and getting this wrong gives
  the error `Cannot obtain the required interface ("IID_IColumnsInfo")`.
- The 5.5 million row table takes a few minutes. That is normal.

Check one table by hand:

```sql
SELECT COUNT(*) FROM stg.mimic_patients;     -- 100
SELECT TOP 5 * FROM stg.mimic_patients;
```

## Step 4: Convert to real types

Open `02_convert.sql`, read one block, then press F5. Each block does three things: drop the table if it
exists, create it with real types, then `INSERT ... SELECT` from staging using `TRY_CONVERT` and `NULLIF`.

## Step 5: Check

Run `03_checks.sql` up to the `DECLARE` line. Every row must say **OK**, and `BadDates` must be 0.
Run the last block only when you are happy: it deletes the staging tables and schema.

## Step 6: Indexes

```powershell
sqlcmd -S localhost -E -C -i D:\sql-practice\medical\setup\indexes.sql
```

Or open `indexes.sql` in SSMS and press F5.

## Step 7: Try it

```sql
USE MedicalPractice;
SELECT COUNT(*) FROM mimic.patients;     -- 100
```

Exercises on this data will be added to this folder.

## Doing a single file with the SSMS wizard instead

For one extra CSV, right-click the database, then **Tasks**, then **Import Flat File**. On the **Modify Columns**
page set every column to `nvarchar(max)` and untick the primary key, so it loads as text like the staging tables.
It is slow for large files and tedious for wide ones, which is why the scripts use `BULK INSERT`.

## Automatic alternative

`medical\setup\load_data.ps1` does steps 2 to 5 in one run (about 8 minutes). It reads the CSV files from your own
folder, so it needs no permission change.
