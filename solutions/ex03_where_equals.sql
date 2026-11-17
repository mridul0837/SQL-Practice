-- Model answer: ex03
USE AdventureWorks2025;
GO

SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color = 'Black';
