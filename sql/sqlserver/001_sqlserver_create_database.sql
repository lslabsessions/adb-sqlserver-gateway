-- LS Lab Sessions
-- Create the SQL Server database used by the gateway lab
-- Run once on the target RDS instance using the admin connection

USE master;
GO

CREATE DATABASE gateway_lab;
GO

SELECT name, state_desc
FROM sys.databases
WHERE name = N'gateway_lab';
GO
