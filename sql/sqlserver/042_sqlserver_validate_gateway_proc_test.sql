USE gateway_lab;
GO

SELECT
    test_marker,
    executed_at
FROM dbo.gateway_proc_test_log
WHERE test_marker = 'ADB_PASSTHROUGH_001';

SELECT COUNT(*) AS rows_after_test
FROM dbo.gateway_proc_test_log
WHERE test_marker = 'ADB_PASSTHROUGH_001';
GO