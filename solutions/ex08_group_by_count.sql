-- Model answer: ex08
USE AdventureWorks2025;
GO

SELECT Color, COUNT(*) AS ProductCount
FROM Production.Product
GROUP BY Color
ORDER BY ProductCount DESC;
