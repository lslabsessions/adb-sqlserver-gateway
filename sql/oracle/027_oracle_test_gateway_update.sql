SELECT "order_id", "quantity", "unit_price", "discount_amount"
FROM "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
WHERE "source_system" = 'GATEWAY_TEST'
  AND "order_id" = 900001
  AND "order_line_id" = 1;

UPDATE "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
SET "quantity" = 3.5
WHERE "source_system" = 'GATEWAY_TEST'
  AND "order_id" = 900001
  AND "order_line_id" = 1;

COMMIT;
