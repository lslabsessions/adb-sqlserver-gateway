-- Replace the hostname placeholder before execution

BEGIN
    DBMS_CLOUD_ADMIN.CREATE_DATABASE_LINK(
        db_link_name       => 'SQLSERVER_NO_GATEWAY',
        hostname           => '<RDS_ENDPOINT>',
        port               => 1433,
        service_name       => 'gateway_lab',
        credential_name    => 'SQLSERVER_INTEGRATION_CRED',
        ssl_server_cert_dn => NULL,
        directory_name     => NULL,
        gateway_link       => FALSE
    );
END;
/

SELECT COUNT(*) AS row_count
FROM "dbo"."sales_order_lines"@SQLSERVER_NO_GATEWAY;
