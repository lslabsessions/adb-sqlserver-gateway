-- Execute as GATEWAY_LAB
-- List files in the gateway wallet directory

SELECT *
FROM DBMS_CLOUD.LIST_FILES('GATEWAY_WALLET_DIR');


-- Execute as GATEWAY_LAB.
-- Download the gateway trust wallet from the private OCI bucket.



-- Verify the downloaded file.
SELECT object_name, bytes
FROM DBMS_CLOUD.LIST_FILES('GATEWAY_WALLET_DIR')
WHERE object_name = 'cwallet.sso';
