/*
  ex08_group_by_count
  Database: AdventureWorks2025

  PROBLEM
  From Production.Product, count how many products there are for each
  Color. Return Color and ProductCount, sorted by ProductCount
  descending. (Notice what happens to products with no color.)
*/
USE AdventureWorks2025;
GO

-- Write your answer below this line
---------------------------------------------------------------
SELECT Color, COUNT(*) AS ProductCount
FROM Production.Product
GROUP BY Color
ORDER BY ProductCount DESC;


