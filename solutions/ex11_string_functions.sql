-- Model answer: ex11_string_functions
USE AdventureWorks2025;
GO

-- Part 1
SELECT LastName + ', ' + FirstName AS FullName,
       LEFT(FirstName, 3)          AS First3,
       UPPER(LastName)             AS LastUpper,
       LEN(FirstName)              AS NameLength
FROM Person.Person
WHERE LastName = 'Adams' AND FirstName LIKE 'A%'
ORDER BY FullName;

-- Part 2
SELECT COUNT(*) AS People,
       COUNT(FirstName + ' ' + MiddleName + ' ' + LastName)    AS FullNamePlus,
       COUNT(CONCAT(FirstName, ' ', MiddleName, ' ', LastName)) AS FullNameConcat,
       SUM(CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END)      AS NoMiddle
FROM Person.Person
WHERE LastName = 'Adams';
