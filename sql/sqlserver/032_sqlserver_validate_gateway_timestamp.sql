USE gateway_lab;
GO

SELECT
    order_id,
    source_updated_at,
    CASE
        WHEN source_updated_at =
             CAST('2026-10-31T12:34:56.789' AS DATETIME2(3))
        THEN 'PASS'
        ELSE 'FAIL'
    END AS timestamp_validation
FROM dbo.sales_order_lines
WHERE source_system = 'GATEWAY_TEST'
  AND order_id = 900002
  AND order_line_id = 1;
GO
