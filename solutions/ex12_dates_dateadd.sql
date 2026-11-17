-- Model answer: ex12_dates_dateadd
USE AdventureWorks2025;
GO

-- Part 1
SELECT TOP 5 SalesOrderID,
       OrderDate,
       DATEADD(DAY, 7, OrderDate)         AS ExpectedShip,
       DATEDIFF(DAY, OrderDate, DueDate)  AS DaysToDue
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID;

-- Part 2
SELECT COUNT(*) AS Orders
FROM Sales.SalesOrderHeader
WHERE OrderDate >= DATEADD(DAY, -30, '2025-06-29');

-- Part 3
SELECT COUNT(*) AS Orders
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2024-06-01'
  AND OrderDate <  DATEADD(MONTH, 1, '2024-06-01');
