SET SERVEROUTPUT ON;

DECLARE
    TYPE t_sales_rows IS TABLE OF sales_export_pending_v%ROWTYPE;
    l_rows          t_sales_rows;
    l_row           sales_export_pending_v%ROWTYPE;
    l_product_name  NVARCHAR2(150);
    l_batch_id      VARCHAR2(36) := RAWTOHEX(SYS_GUID());
    l_inserted      PLS_INTEGER := 0;
    l_updated       PLS_INTEGER := 0;
    l_remote_done   BOOLEAN := FALSE;
BEGIN
    -- Capture the exact source versions included in this batch
    SELECT *
    BULK COLLECT INTO l_rows
    FROM sales_export_pending_v
    ORDER BY order_id, order_line_id;

    IF l_rows.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No pending rows. Nothing to export.');
        RETURN;
    END IF;

    -- Transaction 1: write only to SQL Server
    FOR i IN 1 .. l_rows.COUNT LOOP
        l_row := l_rows(i);
        l_product_name := l_row.product_name;

        UPDATE "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
        SET
            "order_date"        = l_row.order_date,
            "customer_id"       = l_row.customer_id,
            "customer_country"  = l_row.customer_country,
            "product_code"      = l_row.product_code,
            "product_name"      = l_product_name,
            "order_status"      = l_row.order_status,
            "currency_code"     = l_row.currency_code,
            "quantity"          = l_row.quantity,
            "unit_price"        = l_row.unit_price,
            "discount_amount"   = l_row.discount_amount,
            "source_updated_at" = l_row.source_updated_at,
            "load_batch_id"     = l_batch_id
        WHERE "source_system" = l_row.source_system
          AND "order_id" = l_row.order_id
          AND "order_line_id" = l_row.order_line_id;

        IF SQL%ROWCOUNT = 0 THEN
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
                l_row.source_system,
                l_row.order_id,
                l_row.order_line_id,
                l_row.order_date,
                l_row.customer_id,
                l_row.customer_country,
                l_row.product_code,
                l_product_name,
                l_row.order_status,
                l_row.currency_code,
                l_row.quantity,
                l_row.unit_price,
                l_row.discount_amount,
                l_row.source_updated_at,
                l_batch_id
            );

            l_inserted := l_inserted + 1;
        ELSE
            l_updated := l_updated + 1;
        END IF;
    END LOOP;

    COMMIT;
    l_remote_done := TRUE;

    -- Transaction 2: record the exported versions in Oracle
    FOR i IN 1 .. l_rows.COUNT LOOP
        l_row := l_rows(i);

        MERGE INTO sales_export_state dst
        USING (
            SELECT
                l_row.order_id AS order_id,
                l_row.order_line_id AS order_line_id,
                l_row.source_updated_at AS source_updated_at
            FROM dual
        ) src
        ON (
            dst.order_id = src.order_id
            AND dst.order_line_id = src.order_line_id
        )
        WHEN MATCHED THEN
            UPDATE SET
                dst.exported_source_updated_at = src.source_updated_at,
                dst.last_batch_id = l_batch_id,
                dst.exported_at = SYS_EXTRACT_UTC(SYSTIMESTAMP)
        WHEN NOT MATCHED THEN
            INSERT (
                order_id,
                order_line_id,
                exported_source_updated_at,
                last_batch_id,
                exported_at
            )
            VALUES (
                src.order_id,
                src.order_line_id,
                src.source_updated_at,
                l_batch_id,
                SYS_EXTRACT_UTC(SYSTIMESTAMP)
            );
    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Batch: ' || l_batch_id);
    DBMS_OUTPUT.PUT_LINE('Rows inserted: ' || l_inserted);
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || l_updated);
    DBMS_OUTPUT.PUT_LINE('Rows tracked: ' || l_rows.COUNT);
    DBMS_OUTPUT.PUT_LINE('Export completed.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        IF l_remote_done THEN
            DBMS_OUTPUT.PUT_LINE(
                'SQL Server committed; Oracle tracking failed. ' ||
                'Resolve the error and rerun the export.'
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Export failed before confirmed remote commit. ' ||
                'Check the error and destination before retrying.'
            );
        END IF;

        RAISE;
END;
/
