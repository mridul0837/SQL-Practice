/*
  ex09_group_by_aggregates
  Database: AdventureWorks2025

  PROBLEM
  From Sales.SalesOrderHeader, for each order year (YEAR(OrderDate))
  return:
    - OrderYear
    - OrderCount   (number of orders)
    - TotalSales   (sum of TotalDue)
    - AvgOrder     (average TotalDue)
  Sort by OrderYear ascending.
*/
USE AdventureWorks2025;
GO

SELECT
    YEAR(OrderDate)  AS OrderYear,
    COUNT(*)         AS OrderCount,
    SUM(TotalDue)    AS TotalSales,
    AVG(TotalDue)    AS AvgOrder
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;