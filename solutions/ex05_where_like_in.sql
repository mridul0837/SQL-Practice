-- Model answer: ex05
USE AdventureWorks2025;
GO

SELECT FirstName, LastName
FROM Person.Person
WHERE LastName LIKE 'Mc%'
  AND PersonType IN ('EM', 'SC');
