-- Use this script if you want to tune which tables to fetch. Example: exclude system schemas and filter by schema list.
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
AND TABLE_SCHEMA NOT IN ('sys','INFORMATION_SCHEMA')
ORDER BY TABLE_SCHEMA, TABLE_NAME;
