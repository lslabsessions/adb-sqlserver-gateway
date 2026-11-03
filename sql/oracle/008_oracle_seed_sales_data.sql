-- LS Lab Sessions
-- Fictional sales data for the gateway integration lab
-- Run once as GATEWAY_LAB
-- Insert the complete dataset in a single transaction

BEGIN
    INSERT INTO customers
        (customer_id, customer_name, country_code)
    VALUES
        (101, 'Cliente Demonstração Portugal', 'PT');

    INSERT INTO customers
        (customer_id, customer_name, country_code)
    VALUES
        (102, 'Cliente Demostración España', 'ES');

    INSERT INTO customers
        (customer_id, customer_name, country_code)
    VALUES
        (103, 'Client Démonstration France', 'FR');

    INSERT INTO products
        (product_code, product_name, category_name)
    VALUES
        ('KB-001', 'Teclado mecânico', 'Periféricos');

    INSERT INTO products
        (product_code, product_name, category_name)
    VALUES
        ('MS-001', 'Rato sem fios', 'Periféricos');

    INSERT INTO products
        (product_code, product_name, category_name)
    VALUES
        ('MN-001', 'Monitor 27 polegadas', 'Monitores');

    INSERT INTO products
        (product_code, product_name, category_name)
    VALUES
        ('ST-001', 'Suporte de ecrã', 'Acessórios');

    INSERT INTO orders
        (order_id, customer_id, order_date,
         customer_country, order_status, currency_code)
    VALUES
        (1001, 101, DATE '2026-10-15',
         'PT', 'COMPLETED', 'EUR');

    INSERT INTO orders
        (order_id, customer_id, order_date,
         customer_country, order_status, currency_code)
    VALUES
        (1002, 102, DATE '2026-10-16',
         'ES', 'SHIPPED', 'EUR');

    INSERT INTO orders
        (order_id, customer_id, order_date,
         customer_country, order_status, currency_code)
    VALUES
        (1003, 103, DATE '2026-10-17',
         'FR', 'CONFIRMED', 'EUR');

    INSERT INTO order_lines
        (order_id, order_line_id, product_code, product_name,
         quantity, unit_price, discount_amount)
    VALUES
        (1001, 1, 'KB-001', 'Teclado mecânico',
         2, 79.90, 10.00);

    INSERT INTO order_lines
        (order_id, order_line_id, product_code, product_name,
         quantity, unit_price, discount_amount)
    VALUES
        (1001, 2, 'MS-001', 'Rato sem fios',
         2, 24.50, 0);

    INSERT INTO order_lines
        (order_id, order_line_id, product_code, product_name,
         quantity, unit_price, discount_amount)
    VALUES
        (1002, 1, 'MN-001', 'Monitor 27 polegadas',
         1, 249.00, 20.00);

    INSERT INTO order_lines
        (order_id, order_line_id, product_code, product_name,
         quantity, unit_price, discount_amount)
    VALUES
        (1002, 2, 'ST-001', 'Suporte de ecrã',
         1, 45.00, 0);

    INSERT INTO order_lines
        (order_id, order_line_id, product_code, product_name,
         quantity, unit_price, discount_amount)
    VALUES
        (1003, 1, 'KB-001', 'Teclado mecânico',
         1, 79.90, 0);

    INSERT INTO order_lines
        (order_id, order_line_id, product_code, product_name,
         quantity, unit_price, discount_amount)
    VALUES
        (1003, 2, 'MN-001', 'Monitor 27 polegadas',
         2, 249.00, 30.00);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Validate row counts
SELECT 'CUSTOMERS' AS object_name, COUNT(*) AS total_rows
FROM customers
UNION ALL
SELECT 'PRODUCTS', COUNT(*) FROM products
UNION ALL
SELECT 'ORDERS', COUNT(*) FROM orders
UNION ALL
SELECT 'ORDER_LINES', COUNT(*) FROM order_lines
UNION ALL
SELECT 'SALES_EXPORT_STATE', COUNT(*) FROM sales_export_state
UNION ALL
SELECT 'SALES_EXPORT_PENDING_V', COUNT(*) FROM sales_export_pending_v;

-- Check the sales awaiting transfer
SELECT
    order_id,
    order_line_id,
    product_name,
    customer_country,
    order_status,
    quantity,
    unit_price,
    discount_amount,
    quantity * unit_price - discount_amount AS net_amount
FROM sales_export_pending_v
ORDER BY order_id, order_line_id;
