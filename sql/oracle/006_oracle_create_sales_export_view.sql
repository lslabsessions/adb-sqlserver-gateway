-- LS Lab Sessions
-- Export one row per order line
-- Historical sales attributes come from orders and order_lines

CREATE OR REPLACE VIEW sales_export_v AS
SELECT
    CAST('ORACLE_ATP' AS VARCHAR2(20 CHAR)) AS source_system,
    o.order_id,
    ol.order_line_id,
    o.order_date,
    o.customer_id,
    o.customer_country,
    ol.product_code,
    ol.product_name,
    o.order_status,
    o.currency_code,
    ol.quantity,
    ol.unit_price,
    ol.discount_amount,
    GREATEST(
        o.source_updated_at,
        ol.source_updated_at
    ) AS source_updated_at
FROM orders o
JOIN order_lines ol
    ON ol.order_id = o.order_id
	/
	
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN (
    'CUSTOMERS',
    'PRODUCTS',
    'ORDERS',
    'ORDER_LINES',
    'SALES_EXPORT_V'
)
ORDER BY object_type, object_name;

SELECT COUNT(*) AS total_rows
FROM sales_export_v;
