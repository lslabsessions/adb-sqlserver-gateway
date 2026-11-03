-- Source rows and export tracking
SELECT
    (SELECT COUNT(*) FROM sales_export_v) AS source_rows,
    (SELECT COUNT(*) FROM sales_export_pending_v) AS pending_rows,
    (SELECT COUNT(*) FROM sales_export_state) AS tracked_rows;
	
	
-- Inspect the business data awaiting export
SELECT
    source_system,
    order_id,
    order_line_id,
    product_name,
    customer_country,
    order_status,
    quantity,
    unit_price,
    discount_amount,
    quantity * unit_price - discount_amount AS net_amount,
    source_updated_at
FROM sales_export_pending_v
ORDER BY order_id, order_line_id;
