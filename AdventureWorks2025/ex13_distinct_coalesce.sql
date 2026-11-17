/*
  Basics - ex13_distinct_coalesce
  Database: AdventureWorks2025

  PROBLEM
  Part 1: From Production.Product, list every different Color once, with
  products that have no color shown as 'No color' (COALESCE or ISNULL).
  Use SELECT DISTINCT. Sort by Color.

  Part 2: In one row return:
    - Products          COUNT(*)
    - ColorNotNull      COUNT(Color)
    - DistinctColors    COUNT(DISTINCT Color)
  Which ones ignore NULL?

  Part 3: How many different Color + Size combinations are there?
  (DISTINCT applies to the whole row, not just the first column.
  Hint: put SELECT DISTINCT Color, Size in a subquery and COUNT it.)

  CHECK YOURSELF
  Part 1: 10 rows, from Black to Yellow, including 'No color'.
  Part 2: Products 504, ColorNotNull 256, DistinctColors 9.
  Part 3: 68
*/
USE AdventureWorks2025;
GO

-- Write your answer below this line
---------------------------------------------------------------


