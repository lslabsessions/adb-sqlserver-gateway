# Environment and configuration

The project simulated the transfer of sales data from an OLTP source in Oracle Autonomous Database to a data warehouse destination in SQL Server on Amazon RDS. Both cloud environments were hosted in Frankfurt.

## Database environments

Oracle Autonomous Database 26ai held the source tables, the sales export views and the export tracking table in the `GATEWAY_LAB` schema. The sample data represented customers, products, orders and order lines.

The destination was the `gateway_lab` database on Amazon RDS for SQL Server 2022 Express. Its `dbo.sales_order_lines` table received the exported rows. A SQL Server integration login had SELECT, INSERT, UPDATE and DELETE permissions on that table. Direct queries from the SQL Server client provided an independent view of the stored data.

## Gateway host and network

The customer-managed gateway ran on Oracle Linux 9 in EC2, using Oracle Database Gateway for ODBC (`dg4odbc`), unixODBC and Microsoft ODBC Driver 18 for SQL Server. The Oracle installation directory was `/u01/app/oracle/product/26ai/gateway`.

The listener accepted TCPS connections from ADB on port 2484. The ODBC connection reached the RDS endpoint on port 1433. The RDS inbound rule referenced the EC2 security group as its source. Separate external access was also used for the Oracle-managed comparison and direct SQL Server client validation.

The DSN was named `SQLSERVER_LAB`. It selected the `gateway_lab` database and used `Encrypt=yes` with `TrustServerCertificate=no`. The RDS CA certificates were installed in the host's operating-system trust store.

## Certificates and wallet transfer

The gateway server wallet was stored at `/u01/app/oracle/wallets/gateway_server`. The listener and SQL*Net configuration referenced this location. The gateway certificate used the name `CN=lslab-oracle-gateway`.

A separate trust wallet was prepared for ADB. An OCI dynamic group identified the ADB, and an IAM policy granted access to the private wallet bucket. Resource Principal was enabled for the database and the `GATEWAY_LAB` user.

Script 019 copies the trust wallet from the private OCI bucket into an ADB directory. The database link uses the wallet stored in that directory; it does not read the wallet directly from the bucket.

The link references `GATEWAY_WALLET_DIR` for the trust wallet and `SQLSERVER_INTEGRATION_CRED` for SQL Server authentication. Credentials and wallet files are not included in the repository.

## Configuration files

| Repository file | Location on the gateway host | Purpose |
| --- | --- | --- |
| `config/gateway/initsqlserverlab.ora` | `$ORACLE_HOME/hs/admin/initsqlserverlab.ora` | DSN, ODBC library, character and timestamp mappings |
| `config/gateway/listener.ora` | `$ORACLE_HOME/network/admin/listener.ora` | TCPS endpoint and static gateway service |
| `config/gateway/sqlnet.ora` | `$ORACLE_HOME/network/admin/sqlnet.ora` | Wallet location and client certificate authentication setting |
| `config/gateway/odbc.ini` | `/etc/odbc.ini` | SQL Server connection settings |
| `config/gateway/odbcinst.ini` | SQL Server section of `/etc/odbcinst.ini` | Installed Microsoft ODBC driver library |

The final configuration included `HS_LANGUAGE=AMERICAN_AMERICA.WE8ISO8859P1`, `HS_NLS_NCHAR=UCS2` and `HS_FDS_TIMESTAMP_MAPPING=TIMESTAMP`. Their role in the observed errors and tests is described in [troubleshooting](troubleshooting.md).

Environment-specific endpoints, the OCI namespace and passwords are represented by placeholders in the configuration files and SQL scripts.

## Project stages

| Scripts | Work represented |
| --- | --- |
| 001–003 | Creation and validation of the SQL Server destination database and table |
| 004–008 | Creation of the Oracle application schema, source objects, export tracking and sample data |
| 009–010 | SQL Server integration login and permission checks |
| 011–013 | Oracle outbound network information, database link privileges and SQL Server credential |
| 014–017 | Connection without a gateway and Oracle-managed connectivity experiments |
| 018–019 | ADB wallet directory, Resource Principal and trust wallet transfer |
| 020–021 | Customer-managed database link and initial SELECT |
| 022–032 | CRUD, rollback, character encoding and timestamp tests |
| 033–038 | Initial sales export, unchanged rerun and incremental export |
| 039 | Attempt to update SQL Server and Oracle within the same transaction |

The EC2 restart and database link address change are described in [operations](operations.md).
