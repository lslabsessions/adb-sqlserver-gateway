-- Change the discount from 30 to 40.
UPDATE order_lines
SET discount_amount = 40,
    source_updated_at = SYS_EXTRACT_UTC(SYSTIMESTAMP)
WHERE order_id = 1003
  AND order_line_id = 2;

COMMIT;
