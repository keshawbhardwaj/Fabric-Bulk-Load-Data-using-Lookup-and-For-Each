# ✅ 📌 End-to-End Fabric Pipeline: Bulk Load from On-Prem SQL Server → Fabric Lakehouse

You want:

✔️ Lookup → fetch list of tables & schema from SQL Server
✔️ ForEach → loop through each table
✔️ Copy Data → load each table into Fabric Lakehouse
✔️ Pass table & schema using pipeline variables

Below is the full step-by-step solution.

## 🏗 Step 1 — Create a Linked Service (SQL Server On-Prem)

You need Self-Hosted Integration Runtime (SHIR) to connect to on-prem SQL Server.

After setting it up, create linked service:

Fabric portal → Data Engineering → Manage connections → New

Select SQL Server

Use SHIR

Enter:

Server name

Database name

Auth type

Save.

## 🏗 Step 2 — Create Metadata Query for Lookup

Use this query in Lookup activity to fetch all schema + table names:

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;


This returns JSON like:

[
  { "TABLE_SCHEMA": "dbo", "TABLE_NAME": "Customers" },
  { "TABLE_SCHEMA": "sales", "TABLE_NAME": "Orders" },
  ...
]

## 🏗 Step 3 — Create Pipeline Variables

Create two String variables:

schemaName

tableName

## 🏗 Step 4 — ForEach Activity

Configure Items:

@activity('LookupTables').output.value


Inside ForEach, add:

🔹 Set Variable (SchemaName)
@item().TABLE_SCHEMA

🔹 Set Variable (TableName)
@item().TABLE_NAME

🏗 Step 5 — Copy Data Activity (Inside ForEach)
📌 Source: SQL Server

Use dynamic source query:

@concat('SELECT * FROM ', variables('schemaName'), '.', variables('tableName'))


Or if you want schema + table separately:

Table:

@variables('tableName')


Schema:

@variables('schemaName')

📦 Sink: Fabric Lakehouse (Delta Table)

Choose Lakehouse ⇒ Tables

Set dynamic table name:

@variables('tableName')


Fabric will automatically create the table if not exists.

⚙️ Optional Sink Settings

Turn ON:

✔ Auto-create tables
✔ Truncate & Insert (if you want full load)

🔥 Final Pipeline Workflow
Lookup → ForEach (items = lookup output)
          ├─ Set Variable: schemaName
          ├─ Set Variable: tableName
          └─ Copy Data from SQL server → Lakehouse table

🧩 Optional Enhancement: Load Only Specific Schemas

Modify lookup query:

WHERE TABLE_SCHEMA IN ('dbo','sales')
