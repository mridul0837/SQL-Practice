-- Model answer: ex07
USE AdventureWorks2025;
GO

SELECT TOP (10) Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC, Name ASC;
