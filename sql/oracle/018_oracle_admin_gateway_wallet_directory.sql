-- Execute as ADMIN
-- Create the directory used to store the gateway trust wallet

CREATE DIRECTORY GATEWAY_WALLET_DIR AS 'gateway_wallet';

GRANT READ, WRITE ON DIRECTORY GATEWAY_WALLET_DIR
TO GATEWAY_LAB;

-- Verify the directory.
SELECT directory_name, directory_path
FROM all_directories
WHERE directory_name = 'GATEWAY_WALLET_DIR';

-- Verify the application user's permissions.
SELECT grantee, privilege
FROM dba_tab_privs
WHERE table_name = 'GATEWAY_WALLET_DIR'
  AND grantee = 'GATEWAY_LAB'
ORDER BY privilege;

-- Enable resource principal for the database and application user

BEGIN
    DBMS_CLOUD_ADMIN.ENABLE_RESOURCE_PRINCIPAL();

    DBMS_CLOUD_ADMIN.ENABLE_RESOURCE_PRINCIPAL(
        username => 'GATEWAY_LAB'
    );
END;
/

-- Verify the resource principal credential.
SELECT owner, credential_name
FROM dba_credentials
WHERE owner = 'ADMIN'
  AND credential_name = 'OCI$RESOURCE_PRINCIPAL';
