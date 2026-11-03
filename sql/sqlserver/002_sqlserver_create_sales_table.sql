-- LS Lab Sessions
-- Sales reporting destination
-- One row per order line from Oracle ATP
-- Execute once in the existing gateway_lab database

USE gateway_lab;
GO

CREATE TABLE dbo.sales_order_lines
(
    -- Business key from the source system.
    source_system       VARCHAR(20)   NOT NULL,
    order_id            DECIMAL(12,0) NOT NULL,
    order_line_id       DECIMAL(6,0)  NOT NULL,

    -- Business attributes captured for reporting.
    order_date          DATE          NOT NULL,
    customer_id         DECIMAL(12,0) NOT NULL,
    customer_country    CHAR(2)       NOT NULL,
    product_code        VARCHAR(30)   NOT NULL,
    product_name        NVARCHAR(150) NOT NULL,
    order_status        VARCHAR(20)   NOT NULL,
    currency_code       CHAR(3)       NOT NULL,

    -- Amounts exclude tax; discount_amount is for the whole line.
    quantity            DECIMAL(12,3) NOT NULL,
    unit_price          DECIMAL(15,2) NOT NULL,
    discount_amount     DECIMAL(15,2) NOT NULL
        CONSTRAINT DF_sales_order_lines_discount DEFAULT (0),

    -- Integration metadata. All timestamps are UTC.
    source_updated_at   DATETIME2(3)  NOT NULL,
    load_batch_id       VARCHAR(36)   NOT NULL,
    loaded_at           DATETIME2(3)  NOT NULL
        CONSTRAINT DF_sales_order_lines_loaded_at
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_sales_order_lines
        PRIMARY KEY (source_system, order_id, order_line_id),

    CONSTRAINT CK_sales_order_lines_quantity
        CHECK (quantity > 0),

    CONSTRAINT CK_sales_order_lines_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT CK_sales_order_lines_discount
        CHECK
        (
            discount_amount >= 0
            AND discount_amount <= quantity * unit_price
        ),

    CONSTRAINT CK_sales_order_lines_status
        CHECK
        (
            order_status IN
            ('CONFIRMED', 'SHIPPED', 'COMPLETED', 'CANCELLED')
        )
);
GO

CREATE INDEX IX_sales_order_lines_reporting
    ON dbo.sales_order_lines
       (order_date, customer_country, currency_code)
    INCLUDE
       (order_status, quantity, unit_price, discount_amount);
GO

CREATE INDEX IX_sales_order_lines_batch
    ON dbo.sales_order_lines (load_batch_id);
GO
