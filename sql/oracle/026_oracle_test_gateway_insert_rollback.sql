INSERT INTO "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED (
    "source_system",
    "order_id",
    "order_line_id",
    "order_date",
    "customer_id",
    "customer_country",
    "product_code",
    "product_name",
    "order_status",
    "currency_code",
    "quantity",
    "unit_price",
    "discount_amount",
    "source_updated_at",
    "load_batch_id"
)
VALUES (
    'GATEWAY_TEST',
    900003,
    1,
    DATE '2026-10-31',
    101,
    'PT',
    'TEST-ROLLBACK',
    'Rollback test',
    'CONFIRMED',
    'EUR',
    1,
    10,
    0,
    TO_DATE('2026-10-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    'TEST-ROLLBACK-001'
);

-- Run in the same Oracle session with auto-commit disabled.
SELECT COUNT(*) AS rows_before_rollback
FROM "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
WHERE "source_system" = 'GATEWAY_TEST' AND "order_id" = 900003 AND "order_line_id" = 1;

ROLLBACK;

SELECT COUNT(*) AS rows_after_rollback
FROM "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
WHERE "source_system" = 'GATEWAY_TEST' AND "order_id" = 900003 AND "order_line_id" = 1;
