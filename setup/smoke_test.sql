-- Smoke test: confirms the server is up and AdventureWorks is restored.
USE AdventureWorks2025;
GO
SELECT @@VERSION AS ServerVersion;
SELECT DB_NAME() AS CurrentDatabase;
SELECT TOP 10 * FROM Person.Person;
GO
