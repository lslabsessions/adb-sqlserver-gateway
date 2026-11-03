USE gateway_lab;
GO

SELECT
    order_id,
    order_line_id,
    product_name,
    discount_amount,
    CAST(
        quantity * unit_price - discount_amount
        AS DECIMAL(19,2)
    ) AS net_amount,
    source_updated_at,
    load_batch_id
FROM dbo.sales_order_lines
WHERE source_system = 'ORACLE_ATP'
  AND order_id = 1003
  AND order_line_id = 2;

SELECT
    COUNT(*) AS exported_rows,
    CAST(
        SUM(quantity * unit_price - discount_amount)
        AS DECIMAL(19,2)
    ) AS total_net_amount
FROM dbo.sales_order_lines
WHERE source_system = 'ORACLE_ATP';
GO
