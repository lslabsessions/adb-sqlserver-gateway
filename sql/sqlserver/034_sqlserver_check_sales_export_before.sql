USE gateway_lab;
GO

SELECT COUNT(*) AS business_rows_before
FROM dbo.sales_order_lines
WHERE source_system = 'ORACLE_ATP';
GO
