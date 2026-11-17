-- Model answer: ex02
USE AdventureWorks2025;
GO

SELECT Name AS ProductName,
       ListPrice,
       ListPrice * 1.15 AS PriceWithTax
FROM Production.Product;
