USE gateway_lab;
GO

SELECT
    source_system,
    order_id,
    order_line_id,
    product_name,
    quantity,
    unit_price,
    discount_amount,
    CAST(
        quantity * unit_price - discount_amount
        AS DECIMAL(19,2)
    ) AS net_amount,
    load_batch_id,
    loaded_at
FROM dbo.sales_order_lines
WHERE source_system = 'GATEWAY_TEST'
  AND order_id = 900001
  AND order_line_id = 1;
GO


USE gateway_lab;
GO

SELECT COUNT(*) AS rows_after_rollback
FROM dbo.sales_order_lines
WHERE source_system = 'GATEWAY_TEST'
  AND order_id = 900003
  AND order_line_id = 1;
GO
