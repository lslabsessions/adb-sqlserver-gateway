# Oracle Autonomous Database to SQL Server using DB_LINK and Oracle Database Gateway

This lab connects Oracle Autonomous Database in OCI Frankfurt to SQL Server on Amazon RDS in AWS Frankfurt. It compares the Oracle-managed heterogeneous connection with a customer-managed Oracle Database Gateway for ODBC running on EC2.

The managed connection returned SQL Server rows, but the INSERT test failed. With the customer-managed gateway, SELECT, INSERT, UPDATE amd DELETE operations were tested.

This lab simulates a sales data transfer project from an OLTP database in Oracle Autonomous Database to a data warehouse destination in SQL Server on Amazon RDS.

## Recorded results

| Test | Observed result |
| --- | --- |
| Connection without a gateway | Failed |
| Oracle-managed connection | SELECT succeeded; INSERT failed |
| Customer-managed connection | SELECT, INSERT, UPDATE and DELETE succeeded |
| INSERT rollback | The test row was not returned by either the Oracle remote query or the direct SQL Server query after the rollback. |
| National character data | `C@fé` matched on both sides; four characters, eight bytes in the SQL Server test |
| Writes to SQL Server and Oracle without an intermediate commit | Remote UPDATE affected one row; Oracle UPDATE raised ORA-02047; exception handler executed ROLLBACK |
| Timestamp precision | `2026-10-31 12:34:56.789` verified on both sides |
| Initial business export | Six inserts; net total 1020.70 |
| Repeat without source changes on ADB | No pending rows |
| Incremental export | Zero inserts, one update; six destination rows, net total 1010.70 |


## Environment

- Oracle Autonomous Database 26ai; application schema `GATEWAY_LAB`.
- Amazon RDS for SQL Server 2022 Express; database `gateway_lab`.
- Oracle Linux 9 on EC2; Oracle Database Gateway for ODBC (`dg4odbc`).
- Microsoft ODBC Driver 18 for SQL Server; unixODBC.
- TCPS on port 2484 between ADB and the gateway; encrypted SQL Server connection on port 1433.

The customer-managed setup uses Oracle Database Gateway for ODBC (dg4odbc) with Microsoft ODBC Driver 18 for SQL Server.

## Repository guide

| Path | Contents |
| --- | --- |
| `sql/oracle/` | Oracle setup, connection experiments and export scripts |
| `sql/sqlserver/` | Destination setup and independent validation |
| `config/gateway/` | Configuration captured from the working gateway, with placeholders |
| [Setup](docs/setup.md) | Prerequisites and execution order |
| [Tests](docs/testing.md) | Expected results and transaction boundaries |
| [Troubleshooting](docs/troubleshooting.md) | Errors encountered during the lab |
| [Operations](docs/operations.md) | Restarting the lab after EC2 stop/start |

## Before running

The scripts follow the lab sequence, with shared numbering across `sql/oracle/` and `sql/sqlserver/`. Each script is intended for the corresponding Oracle or SQL Server connection. 

Some tests explore successful operations; others reproduce errors that help explain the differences between the connection options. The rollback test uses an Oracle session with auto-commit disabled so the change can be inspected before it is rolled back.

Credentials and wallets are configured locally and are not included in the repository.

## Export design and limits

Script 035 uses **two separate transactions**. In test 039, an UPDATE in SQL Server affected one row, but a subsequent UPDATE in Oracle, without an intermediate commit, failed with `ORA-02047: cannot join the distributed transaction in progress`. The exception handler then executed ROLLBACK.

The export therefore commits the SQL Server changes before recording the exported source versions in Oracle and committing again. The destination data and the Oracle tracking records are not committed atomically. Check [the recorded test](docs/testing.md#distributed-update-test-039).

A failure between them can leave SQL Server updated while Oracle still considers the rows pending. The update-before-insert logic supports replay in this single-writer lab, but failure recovery and concurrent exporters were not tested. The export uses an in-memory collection and has no batching for large datasets. It does not propagate source deletions.
