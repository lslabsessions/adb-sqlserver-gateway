-- Run as GATEWAY_LAB after the update test; deletes only the dedicated test row

DELETE FROM "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
WHERE "source_system" = 'GATEWAY_TEST'
  AND "order_id" = 900001
  AND "order_line_id" = 1;
  
COMMIT;

SELECT COUNT(*) AS rows_after_delete
FROM "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
WHERE "source_system" = 'GATEWAY_TEST'
  AND "order_id" = 900001
  AND "order_line_id" = 1;
