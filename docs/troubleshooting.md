# Errors encountered and configuration changes

The connection tests exposed differences between reaching the gateway, connecting from the gateway to SQL Server, and mapping the returned data into Oracle types.

| Symptom | Observation or change made |
| --- | --- |
| Initial ORA-28500 with malformed ODBC diagnostic text | The connection worked after the `HS_LANGUAGE=AMERICAN_AMERICA.WE8ISO8859P1` setting was applied. This setting is retained in the final gateway configuration. |
| National-character text appeared spaced out | `Gateway insert test` initially returned a length of 38. With `HS_NLS_NCHAR=UCS2`, the text displayed correctly and its length was 19. |
| ORA-02070 mentioning STRUCT TIMESTAMP | The final configuration included `HS_FDS_TIMESTAMP_MAPPING=TIMESTAMP`. The successful precision test used a PL/SQL TIMESTAMP variable. |
| Result-grid display omitted fractional seconds | Script 031 fetched the value into a local TIMESTAMP variable and formatted it with DBMS_OUTPUT. The result showed `.789`, matching the SQL Server validation. |
| ORA-02047 after a remote UPDATE | Test 039 updated one SQL Server row, then attempted an Oracle UPDATE in the same transaction. The Oracle write was rejected and the exception handler executed ROLLBACK. |
| Listener service status UNKNOWN | The `sqlserverlab` service was configured statically in `listener.ora`. The listener was active with a handler for that service. |
| Connection failure after EC2 stop/start | The database link still contained the old public address and the listener was stopped. The link was recreated with the current address and the listener was started; SELECT subsequently worked again. |
| ODBC login timeout / TCP error 0x102 | The diagnostic identified a failed connection from the gateway to the RDS endpoint on port 1433. The exact cause of that timeout was not established. |

The character checks confirmed that C@fé was preserved in both databases.

The distributed update error is documented with its captured output in [test 039](testing.md#distributed-update-test-039). The restart incident is described in [operations](operations.md).

## References

- [Oracle listener status](https://docs.oracle.com/en/database/oracle/oracle-database/26/netag/determining-current-status-listener.html)
- [Oracle Database Gateway for ODBC initialization parameters](https://docs.oracle.com/en/database/oracle/oracle-database/26/odbcu/database-gateway-odbc-initialization-parameters.html)
- [EC2 stop/start behaviour](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-ec2-instance-stop-start-works.html)
- [Dropping ADB database links](https://docs.oracle.com/en-us/iaas/autonomous-database-serverless/doc/database-links-drop.html)
