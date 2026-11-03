-- Replace the hostname placeholder before execution

BEGIN
    DBMS_CLOUD_ADMIN.CREATE_DATABASE_LINK(
        db_link_name       => 'SQLSERVER_CUSTOMER_MANAGED',
        hostname           => '<GATEWAY_HOST>',
        port               => 2484,
        service_name       => 'sqlserverlab',
        ssl_server_cert_dn => 'CN=lslab-oracle-gateway',
        credential_name    => 'SQLSERVER_INTEGRATION_CRED',
        directory_name     => 'GATEWAY_WALLET_DIR',
        gateway_link       => TRUE
    );
END;
/
