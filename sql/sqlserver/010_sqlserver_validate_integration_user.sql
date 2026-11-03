USE gateway_lab;
GO

SELECT
    SUSER_SNAME() AS login_name,
    USER_NAME() AS database_user,
    DB_NAME() AS database_name;
GO

SELECT permission_name
FROM sys.fn_my_permissions(
    'dbo.sales_order_lines',
    'OBJECT'
)
WHERE ISNULL(subentity_name, '') = ''
  AND permission_name IN (
      'SELECT', 'INSERT', 'UPDATE', 'DELETE'
  )
ORDER BY permission_name;
GO

SELECT COUNT(*) AS total_rows
FROM dbo.sales_order_lines;
GO
