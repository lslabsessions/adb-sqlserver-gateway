DECLARE
    l_source_updated_at TIMESTAMP(3) :=
        TIMESTAMP '2026-10-31 12:34:56.789';
BEGIN
    UPDATE "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
    SET "source_updated_at" = l_source_updated_at
    WHERE "source_system" = 'GATEWAY_TEST'
      AND "order_id" = 900002
      AND "order_line_id" = 1;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    l_timestamp TIMESTAMP(3);
BEGIN
    SELECT "source_updated_at"
    INTO l_timestamp
    FROM "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
    WHERE "source_system" = 'GATEWAY_TEST'
      AND "order_id" = 900002
      AND "order_line_id" = 1;

    DBMS_OUTPUT.PUT_LINE(
        'Timestamp recebido: ' ||
        TO_CHAR(l_timestamp, 'YYYY-MM-DD HH24:MI:SS.FF3')
    );
END;
/

COMMIT;
