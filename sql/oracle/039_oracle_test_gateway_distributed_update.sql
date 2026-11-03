-- Run as GATEWAY_LAB with client auto-commit disabled
-- Requires test row 900002 and export tracking row 1001/1
-- Expected: SQL Server updates one row, then Oracle raises ORA-02047

-- Oracle Database Gateway for ODBC uses the SINGLE_SITE transaction model
-- After DML in SQL Server, DML in Oracle within the same transaction raises
-- ORA-02047: cannot join the distributed transaction in progress
-- Commit the SQL Server transaction before executing DML in Oracle
-- The two sets of changes are therefore committed separately

SET SERVEROUTPUT ON;

BEGIN
    -- Write to SQL Server.
    UPDATE "dbo"."sales_order_lines"@SQLSERVER_CUSTOMER_MANAGED
    SET "quantity" = "quantity" + 1
    WHERE "source_system" = 'GATEWAY_TEST'
      AND "order_id" = 900002
      AND "order_line_id" = 1;

    DBMS_OUTPUT.PUT_LINE('SQL Server: ' || SQL%ROWCOUNT || ' ROW(s).');

    -- Write to Oracle without committing the remote transaction.
    UPDATE sales_export_state
    SET exported_at = SYSTIMESTAMP
    WHERE order_id = 1001
      AND order_line_id = 1;

    DBMS_OUTPUT.PUT_LINE('Oracle: ' || SQL%ROWCOUNT || ' ROW(s).');

    -- Safety addition to the captured test: also roll back unexpected success.
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Both updates succeeded; rollback executed. Review the result.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ROLLBACK AFTER ERROR.');
END;
/
