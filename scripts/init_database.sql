/*
===================================================================
Create Database and Schemas
===================================================================
Script Purpose:
  This script create a new database named 'DataWarehouse' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
  within the database:'bronze','Silver', and 'gold'.

WARNING:
  Running this scripts will drop the entire 'DataWarehouse' database if it exists.
  All data in the database will be premanently deleted.proceed with caution and ensure you have proper backups
  befor running this script.
*/



USE Master;
GO

--Drop and Recreate the 'datawarehouse' database
IF EXISTS( SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER with RollBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

--Create a 'Data Warehouse' Database.
create DATABASE DataWarehouse;

use Datawarehouse;

--Create Schemas for Bronze,silver and Gold Layer
CREATE SCHEMA bronze;
GO
CREATE SCHEMA Siver;
GO
CREATE SCHEMA gold;
GO
