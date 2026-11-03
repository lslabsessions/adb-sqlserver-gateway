-- Run once: create a separate Unicode test row.
DECLARE
l_product_name NVARCHAR2(150) := 'C@fé';
BEGIN
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
        900002,
        1,
        DATE '2026-10-31',
        101,
        'PT',
        'TEST-UNICODE',
        l_product_name,
        'CONFIRMED',
        'EUR',
        1,
        19.90,
        0,
        TO_DATE('2026-10-31 12:34:56', 'YYYY-MM-DD HH24:MI:SS'),
        'TEST-UNICODE-001'
    );
END;
/

COMMIT;
