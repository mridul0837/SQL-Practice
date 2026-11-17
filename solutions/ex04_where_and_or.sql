-- Model answer: ex04
USE AdventureWorks2025;
GO

SELECT Name, Color, ListPrice
FROM Production.Product
WHERE (Color = 'Red' OR Color = 'Silver')
  AND ListPrice > 500;
