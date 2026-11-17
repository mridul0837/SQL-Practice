-- Model answer: ex09
USE AdventureWorks2025;
GO

SELECT YEAR(OrderDate) AS OrderYear,
       COUNT(*)      AS OrderCount,
       SUM(TotalDue) AS TotalSales,
       AVG(TotalDue) AS AvgOrder
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;
