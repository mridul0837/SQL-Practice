/*
  Basics - ex12_dates_dateadd
  Database: AdventureWorks2025

  PROBLEM
  Part 1: From Sales.SalesOrderHeader, for the 5 orders with the lowest
  SalesOrderID return:
    - SalesOrderID
    - OrderDate
    - ExpectedShip   OrderDate plus 7 days    (DATEADD)
    - DaysToDue      days from OrderDate to DueDate   (DATEDIFF)
  Sort by SalesOrderID.

  Part 2: How many orders were placed in the 30 days up to and including
  the last order date in the data (2025-06-29)?
  Hint: OrderDate >= DATEADD(DAY, -30, '2025-06-29')

  Part 3: How many orders were placed in June 2024? Write it as a date
  range, not with YEAR() and MONTH():
     OrderDate >= '2024-06-01'  AND  OrderDate < DATEADD(MONTH, 1, '2024-06-01')
  (A range lets SQL Server use an index; YEAR(OrderDate) = 2024 cannot.)

  Note: this copy of AdventureWorks has orders from 2022 to mid-2025.

  CHECK YOURSELF
  Part 1: first row is 43659 | 2022-05-30 | 2022-06-06 | 12
  Part 2: 976
  Part 3: 741
*/
USE AdventureWorks2025;
GO

-- Write your answer below this line
---------------------------------------------------------------


