/*
  Basics - ex11_string_functions
  Database: AdventureWorks2025

  PROBLEM
  Part 1: From Person.Person, for people whose LastName is 'Adams' AND whose
  FirstName starts with 'A', return:
    - FullName     in the form  Adams, Aaron   (LastName, comma, space, FirstName)
    - First3       the first 3 letters of FirstName   (LEFT)
    - LastUpper    LastName in capitals   (UPPER)
    - NameLength   number of characters in FirstName   (LEN)
  Sort by FullName.

  Part 2: NULL ruins concatenation. For ALL people whose LastName is 'Adams',
  return in one row:
    - People            how many rows (COUNT(*))
    - FullNamePlus      COUNT of FirstName + ' ' + MiddleName + ' ' + LastName
    - FullNameConcat    COUNT of CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
    - NoMiddle          how many have MiddleName NULL
  COUNT(expression) skips NULLs, so these counts show how many names
  survived. Why are the two counts different?

  CHECK YOURSELF
  Part 1: 9 rows. The first is  Adams, Aaron | Aar | ADAMS | 5
  Part 2: People 86, FullNamePlus 55, FullNameConcat 86, NoMiddle 31.
          (+ with a NULL gives NULL; CONCAT treats NULL as empty text.)
*/
USE AdventureWorks2025;
GO

-- Write your answer below this line
---------------------------------------------------------------


