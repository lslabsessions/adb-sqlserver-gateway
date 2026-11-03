# Restart behaviour observed during the project

The EC2 instance used an automatically assigned public IPv4 address. After a stop/start cycle, the instance had a new public address, while the customer-managed database link still held the previous address.

The difference was confirmed by comparing the EC2 instance details with the connection descriptor returned by:

```sql
SELECT db_link, host
FROM user_db_links
WHERE db_link LIKE 'SQLSERVER_CUSTOMER_MANAGED%';
```

## Listener state

The listener was also stopped after the host restart. It was started under the Oracle software owner, and its status was checked with:

```bash
lsnrctl start LISTENER
lsnrctl status LISTENER
```

The output showed a TCPS endpoint on port 2484 and one handler for `sqlserverlab`. The service status was `UNKNOWN`, reflecting its static registration in `listener.ora`.

## Database link address

The existing link was dropped and recreated with the current EC2 public address using the same service, credential and wallet directory. The drop operation was:

```sql
BEGIN
    DBMS_CLOUD_ADMIN.DROP_DATABASE_LINK(
        db_link_name => 'SQLSERVER_CUSTOMER_MANAGED'
    );
END;
/
```

Script 020 contains the creation call of the dabase link. The existing gateway certificate and SQL Server credentials were retained, so the trust wallet and Oracle credential did not need to be recreated after the address change.