-- LS Lab Sessions
-- Run once using the RDS admin connection.

USE gateway_lab;
GO

CREATE TABLE dbo.gateway_proc_test_log (
    test_marker varchar(40) NOT NULL PRIMARY KEY,
    executed_at datetime2(3) NOT NULL
        DEFAULT SYSUTCDATETIME()
);
GO

CREATE PROCEDURE dbo.gateway_proc_test
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.gateway_proc_test_log (test_marker)
    VALUES ('ADB_PASSTHROUGH_001');
END;
GO

GRANT EXECUTE ON OBJECT::dbo.gateway_proc_test
TO gateway_integration;
GO

SELECT
    OBJECT_NAME(OBJECT_ID(N'dbo.gateway_proc_test', N'P')) AS procedure_name,
    COUNT(*) AS rows_before_test
FROM dbo.gateway_proc_test_log;
GO