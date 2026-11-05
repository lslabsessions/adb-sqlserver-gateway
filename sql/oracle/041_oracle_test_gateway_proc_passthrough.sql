SET SERVEROUTPUT ON

DECLARE
    l_result INTEGER;
BEGIN
    l_result :=
        DBMS_HS_PASSTHROUGH.EXECUTE_IMMEDIATE@SQLSERVER_CUSTOMER_MANAGED(
            'EXEC dbo.gateway_proc_test'
        );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pass-through call completed and committed.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/