# SQL Practice: T-SQL for AdventureWorks2025

A hands-on T-SQL tutorial built around Microsoft's **AdventureWorks2025** sample database.
Each exercise is a short problem written as a comment at the top of a `.sql` file.
You write the query underneath, run it, and compare with the model answer.

## What you will learn

| Exercise | Topic |
| --- | --- |
| `ex01_select_columns` | `SELECT` specific columns |
| `ex02_aliases_and_expressions` | Column aliases (`AS`) and calculated columns |
| `ex03_where_equals` | Filtering with `WHERE` |
| `ex04_where_and_or` | Combining conditions with `AND` / `OR` and parentheses |
| `ex05_where_like_in` | Pattern matching with `LIKE`, lists with `IN` |
| `ex06_where_null_between` | `IS NULL` and `BETWEEN` |
| `ex07_order_by_top` | Sorting with `ORDER BY`, limiting rows with `TOP` |
| `ex08_group_by_count` | `GROUP BY` with `COUNT` |
| `ex09_group_by_aggregates` | `SUM`, `AVG`, `MIN`, `MAX` per group |
| `ex10_having` | Filtering groups with `HAVING` |
| `ex11_string_functions` | `LEFT`, `UPPER`, `LEN`, `CONCAT`, and why `NULL` breaks `+` |
| `ex12_dates_dateadd` | `DATEADD`, `DATEDIFF`, date ranges |
| `ex13_distinct_coalesce` | `DISTINCT`, `COALESCE`, `COUNT(*)` vs `COUNT(col)` |


## Repository layout

| Folder | Contents |
| --- | --- |
| `AdventureWorks2025/` | The exercises. Each file states the problem, then has a blank space for your answer. |
| `solutions/` | Model answers. Try the exercise first. |
| `setup/` | How to connect (`connect.md`) and a smoke test (`smoke_test.sql`). |
| `medical/` | Scripts to build a local `MedicalPractice` database from public medical datasets. Start at `medical/setup/manual/MANUAL.md`. Exercises will be added later. |

## Requirements

- SQL Server (the Developer edition is free) with the **AdventureWorks2025** database restored.
  The sample database can be downloaded from Microsoft:
  https://learn.microsoft.com/sql/samples/adventureworks-install-configure
- SQL Server Management Studio (SSMS), or `sqlcmd`, to run the queries.

Connection steps are in [setup/connect.md](setup/connect.md). Run
[setup/smoke_test.sql](setup/smoke_test.sql) to check that the database is working.

## How to use it

1. Open an exercise, for example `AdventureWorks2025/ex01_select_columns.sql`, in SSMS.
2. Read the problem in the comment at the top.
3. Write your query under the line `-- Write your answer below this line`.
4. Select your query and press **F5**. If nothing is selected, F5 runs the whole file.
5. Stuck? Compare with the file of the same name in `solutions/`, then rewrite the query from memory.

Each file starts with `USE AdventureWorks2025;` and `GO`. `USE` picks the database,
and `GO` is a batch separator understood by SSMS and `sqlcmd` (it is not T-SQL itself).

To run a file from the terminal:

```powershell
sqlcmd -S localhost -E -C -d AdventureWorks2025 -i AdventureWorks2025\ex01_select_columns.sql
```

## Data and licence note

AdventureWorks is a fictional company's sample data published by Microsoft. It contains no real people.
It is not included in this repository.
