/*
  ex10_having
  Database: AdventureWorks2025

  PROBLEM
  From Sales.SalesOrderHeader, find customers (CustomerID) who have
  placed at least 25 orders. Return CustomerID and OrderCount, sorted
  by OrderCount descending, then CustomerID ascending.
*/
USE AdventureWorks2025;
GO

SELECT
    CustomerID,
    COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) >= 25
ORDER BY OrderCount DESC, CustomerID ASC;
