-- Step 1: create the empty database and the four schemas.
-- Run this connected to the master database (any query window on localhost).
-- SQL Server creates MedicalPractice.mdf (data) and MedicalPractice_log.ldf (log) itself.
IF DB_ID('MedicalPractice') IS NULL CREATE DATABASE MedicalPractice;
GO
USE MedicalPractice;
GO
CREATE SCHEMA stg;      -- staging: raw text copies of the CSV files (dropped at the end)
GO
CREATE SCHEMA mimic;    -- hospital data
GO
CREATE SCHEMA synpuf;   -- Medicare claims (synthetic)
GO
CREATE SCHEMA partd;    -- Medicare Part D drug spending
GO
