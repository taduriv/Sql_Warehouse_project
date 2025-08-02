/*
======================================================================
STORED PROCEDURE: LOAD BRONZE LAYER ( SOURCE ->BRONZE)
======================================================================
Script purpose:
This stored procedure loads the data into bronze schema from external csv files.
If performs following actions:
-Truncates the bronze tabes before loading the data (TRUNCATE and FULL LOAD)
-The Bulk Insert command load the data from CSV to Bronze table
-TABLOCK is used for faster processing and loading the data into the table

Example load Query:
EXEC bronze.load_bronze;
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
Declare @start_time DATETIME,@end_time DATETIME, @batch_start_time DATETIME,@batch_end_time DATETIME;
	BEGIN TRY
			SET @batch_start_time=GETDATE();
			PRINT'=================================='
			PRINT 'Loading the Bronze layer'
			PRINT'=================================='
			PRINT '---------------------------------'
			PRINT'LOADING CRM TABLES'
			PRINT '---------------------------------'
			SET @start_time=GETDATE();
			TRUNCATE TABLE bronze.crm_cust_info;
			BULK INSERT bronze.crm_cust_info
			FROM 'C:\Users\Vishal Taduri\OneDrive\Desktop\DataWarehouseProject\source_crm\cust_info.csv'
			WITH (
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				TABLOCK
			);
			SET @end_time=GETDATE();
			PRINT '>> LOAD DURATION :'+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';

			PRINT '>> TRUNCATING TABLE crm_prd_id'
			TRUNCATE TABLE bronze.crm_prd_id;
			BULK INSERT bronze.crm_prd_id
			FROM 'C:\Users\Vishal Taduri\OneDrive\Desktop\DataWarehouseProject\source_crm\prd_info.csv'
			WITH (
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				TABLOCK
			);

			TRUNCATE TABLE bronze.crm_sales_details;
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\Vishal Taduri\OneDrive\Desktop\DataWarehouseProject\source_crm\sales_details.csv'
			WITH (
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				TABLOCK
			);

			PRINT '---------------------------------'
			PRINT 'LOADING ERP TABLES'
			PRINT '---------------------------------'
			TRUNCATE TABLE bronze.erp_loc_a101;
			BULK INSERT bronze.erp_loc_a101
			FROM 'C:\Users\Vishal Taduri\OneDrive\Desktop\DataWarehouseProject\source_erp\LOC_A101.csv'
			WITH (
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				TABLOCK
			);

			TRUNCATE TABLE bronze.erp_cust_az12;
			BULK INSERT bronze.erp_cust_az12
			FROM 'C:\Users\Vishal Taduri\OneDrive\Desktop\DataWarehouseProject\source_erp\CUST_AZ12.csv'
			WITH (
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				TABLOCK
			);

			TRUNCATE TABLE bronze.erp_px_cat_g1v2;
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'C:\Users\Vishal Taduri\OneDrive\Desktop\DataWarehouseProject\source_erp\PX_CAT_G1V2.csv'
			WITH (
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				TABLOCK
			);
			SET @batch_end_time=GETDATE();
			PRINT'==========================================='
			PRINT 'LOADING BRONZE LAYER IS COMPLETED'
			PRINT 'TOTAL LOAD DURATION:'+CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR)+'Seconds'
			PRINT'==========================================='

		END TRY
		BEGIN CATCH
			PRINT '=================================================='
			PRINT 'ERROR OCCURED DURING BRONZE LAYER'
			PRINT '=================================================='
			PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
			PRINT 'ERROR MESSAGE' + CAST( ERROR_NUMBER() AS NVARCHAR);
			PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR)
		END CATCH
END
