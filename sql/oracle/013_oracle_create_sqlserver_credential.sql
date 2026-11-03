-- Replace the password placeholder before execution

BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
        credential_name => 'SQLSERVER_INTEGRATION_CRED',
        username        => 'GATEWAY_INTEGRATION',
        password        => '<SQLSERVER_PASSWORD>'
    );
END;
/

SELECT
    credential_name,
    username,
    enabled
FROM user_credentials
WHERE credential_name = 'SQLSERVER_INTEGRATION_CRED';
