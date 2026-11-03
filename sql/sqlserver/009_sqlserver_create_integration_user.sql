-- LS Lab Sessions
-- Run once using the RDS admin connection
-- Replace the password placeholder before execution

USE master;
GO

CREATE LOGIN gateway_integration
WITH
    PASSWORD = '<USER_PASSWORD>',
    DEFAULT_DATABASE = gateway_lab,
    CHECK_POLICY = ON,
    CHECK_EXPIRATION = OFF;
GO

USE gateway_lab;
GO

CREATE USER gateway_integration
FOR LOGIN gateway_integration
WITH DEFAULT_SCHEMA = dbo;
GO

GRANT CONNECT TO gateway_integration;

GRANT SELECT, INSERT, UPDATE, DELETE
ON OBJECT::dbo.sales_order_lines
TO gateway_integration;
GO
