-- LS Lab Sessions
-- Run as ADMIN
-- Inspect outbound routing without changing configuration

SELECT property_name, property_value
FROM database_properties
WHERE property_name = 'ROUTE_OUTBOUND_CONNECTIONS';

SELECT
    JSON_QUERY(
        cloud_identity,
        '$.OUTBOUND_IP_ADDRESS'
    ) AS outbound_ip_addresses
FROM v$pdbs;
