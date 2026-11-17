-- Model answer: ex13_distinct_coalesce
USE AdventureWorks2025;
GO

-- Part 1
SELECT DISTINCT COALESCE(Color, 'No color') AS Color
FROM Production.Product
ORDER BY Color;

-- Part 2
SELECT COUNT(*)              AS Products,
       COUNT(Color)          AS ColorNotNull,
       COUNT(DISTINCT Color) AS DistinctColors
FROM Production.Product;

-- Part 3
SELECT COUNT(*) AS DistinctPairs
FROM (SELECT DISTINCT Color, Size FROM Production.Product) AS x;
