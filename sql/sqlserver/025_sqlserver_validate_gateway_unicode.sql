USE gateway_lab;
GO

SELECT
    order_id,
    product_name,
    LEN(product_name) AS character_count,
    DATALENGTH(product_name) AS byte_count,
    CASE
        WHEN CONVERT(VARBINARY(MAX), product_name) =
             CONVERT(VARBINARY(MAX), N'C@fé')
        THEN 'PASS'
        ELSE 'FAIL'
    END AS unicode_validation,
    source_updated_at,
    load_batch_id
FROM dbo.sales_order_lines
WHERE source_system = 'GATEWAY_TEST'
  AND order_id = 900002
  AND order_line_id = 1;
GO
