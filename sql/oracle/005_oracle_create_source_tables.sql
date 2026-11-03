-- LS Lab Sessions
-- Operational sales model.
-- Run once as GATEWAY_LAB.
-- All *_updated_at timestamps use UTC.
-- Application code must update these timestamps on changes.

CREATE TABLE customers (
    customer_id       NUMBER(12,0)      NOT NULL,
    customer_name     VARCHAR2(150 CHAR) NOT NULL,
    country_code      CHAR(2 CHAR)      NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
)
/

CREATE TABLE products (
    product_code      VARCHAR2(30 CHAR)  NOT NULL,
    product_name      VARCHAR2(150 CHAR) NOT NULL,
    category_name     VARCHAR2(60 CHAR)  NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_code)
)
/

CREATE TABLE orders (
    order_id          NUMBER(12,0)     NOT NULL,
    customer_id       NUMBER(12,0)     NOT NULL,
    order_date        DATE             NOT NULL,
    customer_country  CHAR(2 CHAR)     NOT NULL,
    order_status      VARCHAR2(20 CHAR) NOT NULL,
    currency_code     CHAR(3 CHAR)     NOT NULL,
    source_updated_at TIMESTAMP(3)
        DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,

    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id),
    CONSTRAINT ck_orders_status
        CHECK (
            order_status IN
            ('CONFIRMED', 'SHIPPED', 'COMPLETED', 'CANCELLED')
        ),
    CONSTRAINT ck_orders_date
        CHECK (order_date = TRUNC(order_date))
)
/

CREATE TABLE order_lines (
    order_id          NUMBER(12,0)      NOT NULL,
    order_line_id     NUMBER(6,0)       NOT NULL,
    product_code      VARCHAR2(30 CHAR) NOT NULL,
    product_name      VARCHAR2(150 CHAR) NOT NULL,
    quantity          NUMBER(12,3)      NOT NULL,
    unit_price        NUMBER(15,2)      NOT NULL,
    discount_amount   NUMBER(15,2) DEFAULT 0 NOT NULL,
    source_updated_at TIMESTAMP(3)
        DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,

    CONSTRAINT pk_order_lines
        PRIMARY KEY (order_id, order_line_id),
    CONSTRAINT fk_order_lines_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT fk_order_lines_product
        FOREIGN KEY (product_code)
        REFERENCES products (product_code),
    CONSTRAINT ck_order_lines_quantity
        CHECK (quantity > 0),
    CONSTRAINT ck_order_lines_price
        CHECK (unit_price >= 0),
    CONSTRAINT ck_order_lines_discount
        CHECK (
            discount_amount >= 0
            AND discount_amount <= quantity * unit_price
        )
)
/

CREATE INDEX ix_orders_customer
    ON orders (customer_id)
	/

CREATE INDEX ix_order_lines_product
    ON order_lines (product_code)
	/
