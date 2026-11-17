-- Model answer: ex10
USE AdventureWorks2025;
GO

SELECT CustomerID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) >= 25
ORDER BY OrderCount DESC, CustomerID ASC;
