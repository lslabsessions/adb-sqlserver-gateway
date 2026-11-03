-- Run as ADMIN.
-- Replace the user password placeholder before execution

CREATE USER gateway_lab
    IDENTIFIED BY "<USER_PASSWORD>"
    DEFAULT TABLESPACE DATA
    QUOTA 100M ON DATA
	/

GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      CREATE PROCEDURE
TO gateway_lab
/
