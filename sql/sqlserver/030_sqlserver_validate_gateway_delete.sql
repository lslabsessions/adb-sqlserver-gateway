-- Reconstructed from screenshot 078; original file absent from source archive.
USE gateway_lab;
GO
SELECT COUNT(*) AS rows_after_delete
FROM dbo.sales_order_lines
WHERE source_system = 'GATEWAY_TEST'
  AND order_id = 900001
  AND order_line_id = 1;
GO
