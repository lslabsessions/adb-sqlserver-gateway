-- LS Lab Sessions
-- Validate the destination and inspect transferred sales

USE gateway_lab;
GO

-- Confirm the table structure.
SELECT
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'sales_order_lines'
ORDER BY ORDINAL_POSITION;
GO

-- Initially expected: 0 rows.
SELECT COUNT(*) AS total_rows
FROM dbo.sales_order_lines;
GO

-- Inspect integration batches after loading data.
SELECT
    load_batch_id,
    COUNT(*) AS current_rows_in_batch,
    MIN(loaded_at) AS first_loaded_at_utc,
    MAX(loaded_at) AS last_loaded_at_utc
FROM dbo.sales_order_lines
GROUP BY load_batch_id
ORDER BY last_loaded_at_utc DESC;
GO

-- Daily completed sales, separated by country and currency.
SELECT
    order_date,
    customer_country,
    currency_code,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(
        CAST(
            quantity * unit_price - discount_amount
            AS DECIMAL(19,2)
        )
    ) AS net_sales_amount
FROM dbo.sales_order_lines
WHERE source_system = 'ORACLE_ATP'
  AND order_status = 'COMPLETED'
GROUP BY
    order_date,
    customer_country,
    currency_code
ORDER BY
    order_date,
    customer_country,
    currency_code;
GO
