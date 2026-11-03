USE gateway_lab;
GO

SELECT
    order_id,
    quantity,
    unit_price,
    discount_amount,
    CAST(
        quantity * unit_price - discount_amount
        AS DECIMAL(19,2)
    ) AS net_amount
FROM dbo.sales_order_lines
WHERE source_system = 'GATEWAY_TEST'
  AND order_id = 900001
  AND order_line_id = 1;
GO
