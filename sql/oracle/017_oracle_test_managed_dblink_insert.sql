INSERT INTO "dbo"."sales_order_lines"@SQLSERVER_ORACLE_MANAGED (
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
    "load_batch_id",
    "loaded_at"
)
VALUES (
    'GATEWAY_TEST',
    999999,
    1,
    DATE '2026-10-20',
    101,
    'PT',
    'TEST-001',
    'Oracle-managed write test',
    'CONFIRMED',
    'EUR',
    1,
    10,
    0,
    TIMESTAMP '2026-10-20 00:00:00',
    'MANAGED-WRITE-TEST',
    TIMESTAMP '2026-10-20 00:00:00'
);

ROLLBACK;

SELECT COUNT(*) AS row_count
FROM "dbo"."sales_order_lines"@SQLSERVER_ORACLE_MANAGED;
