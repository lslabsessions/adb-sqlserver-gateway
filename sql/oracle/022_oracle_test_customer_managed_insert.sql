SELECT COUNT(*) AS existing_test_rows
FROM "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
WHERE "source_system" = 'GATEWAY_TEST'
  AND "order_id" = 900001
  AND "order_line_id" = 1;
  
INSERT INTO "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
(
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
VALUES
(
    'GATEWAY_TEST',
    900001,
    1,
    DATE '2026-10-31',
    101,
    'PT',
    'TEST-001',
    'Gateway insert test',
    'CONFIRMED',
    'EUR',
    2.500,
    19.90,
    1.25,
    DATE '2026-10-31',
    'TEST-INSERT-001'
);

COMMIT;
