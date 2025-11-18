# Fabric-Bulk-Load-Data-using-Lookup-and-For-Each
To Bulk load data from On Prem SQL Server to Fabric Lakehouse using Lookup and For Each. 

# Bulk load SQL Server (on-prem) → Fabric Lakehouse


This repository contains a Fabric/ADF-style pipeline that:


1. Runs a Lookup to get all tables (schema + name) from an on-prem SQL Server
2. Loops over each table using ForEach
3. Copies data for each table into a Lakehouse table (Delta)


> The pipeline is written in JSON (ADF/pipeline format) so it can be imported into Fabric's pipeline designer or used with ARM/CI pipelines.


### What you need before using


- Self-Hosted Integration Runtime (SHIR) installed and configured to access the on-prem SQL Server
- Connection details for the SQL Server (username/password or managed identity as required)
- Fabric workspace and Lakehouse access


### How to use


1. Update the linked service JSONs (linkedServices/sqlserver_linkedservice.json and linkedServices/lakehouse_linkedservice.json) with your connection values or create connections in the Fabric UI and adjust `referenceName` in pipeline.json.
2. Import `pipelines/lookup_foreach_copy/pipeline.json` into Fabric pipeline designer (or use deployment scripts).
3. Ensure the SHIR is running and accessible to Fabric.
4. Run the pipeline.


### Notes


- The Copy activity in this example uses a full-table `SELECT *` (simple full loads). For large tables, replace it with incremental logic (CDC, watermark columns, or T-SQL queries filtering by date/PK).
- Error handling: add retry policies and a logging sink (e.g., a metadata table in SQL or Storage) for production.
