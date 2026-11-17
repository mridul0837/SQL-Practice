-- Model answer: ex06
USE AdventureWorks2025;
GO

SELECT Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NULL
  AND ListPrice BETWEEN 10 AND 100;
