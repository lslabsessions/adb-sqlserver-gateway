-- LS Lab Sessions
-- Track the source version successfully exported for each order line
-- All timestamps use UTC
-- Run once as GATEWAY_LAB

CREATE TABLE sales_export_state (
    order_id                    NUMBER(12,0)     NOT NULL,
    order_line_id               NUMBER(6,0)      NOT NULL,
    exported_source_updated_at  TIMESTAMP(3)     NOT NULL,
    last_batch_id               VARCHAR2(36 CHAR) NOT NULL,
    exported_at                 TIMESTAMP(3)     NOT NULL,

    CONSTRAINT pk_sales_export_state
        PRIMARY KEY (order_id, order_line_id)
)
/


CREATE OR REPLACE VIEW sales_export_pending_v AS
SELECT
    s.source_system,
    s.order_id,
    s.order_line_id,
    s.order_date,
    s.customer_id,
    s.customer_country,
    s.product_code,
    s.product_name,
    s.order_status,
    s.currency_code,
    s.quantity,
    s.unit_price,
    s.discount_amount,
    s.source_updated_at
FROM sales_export_v s
LEFT JOIN sales_export_state e
    ON  e.order_id      = s.order_id
    AND e.order_line_id = s.order_line_id
WHERE e.order_id IS NULL
   OR s.source_updated_at > e.exported_source_updated_at
   /

-- Validate the new objects.
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN (
    'SALES_EXPORT_STATE',
    'SALES_EXPORT_PENDING_V'
)
ORDER BY object_type, object_name;

SELECT COUNT(*) AS pending_rows
FROM sales_export_pending_v;
