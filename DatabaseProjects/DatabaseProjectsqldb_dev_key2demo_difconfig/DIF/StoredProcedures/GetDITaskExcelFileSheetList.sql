






-- =============================================
-- Author:		Key2
-- Create date: 2023-06-01
-- Description:	Used to fetch Excel file to parquet task data. Assembles destination file folder and file name prefix and joins to source/destination attributes pulled from DITaskDetail

/*
EXEC [DIF].[GetDITaskExcelFileSheetList]
	@DITaskKey = 127

*/


-- =============================================


CREATE PROCEDURE [DIF].[GetDITaskExcelFileSheetList]
(
	@DITaskKey INT
	/*@MaxWaterMark VARCHAR(255)*/  --leave commented for now to support IngestionFileName and LoadFolder attributes
)
AS


BEGIN

	DECLARE	@TestDIGroupTaskKey INT;	

	BEGIN TRY

		SELECT
			@TestDIGroupTaskKey = a.[DITaskKey]
		FROM
			[config].DITask AS a
		WHERE
			a.DITaskKey = @DITaskKey;

		IF @TestDIGroupTaskKey IS NULL
			THROW 50101, 'An unknown data integration task was identified by the @DITaskKey parameter.', 1;

		
		SELECT 
			L.*
		FROM 
			[DIF].[udf_GetDITaskExcelFileSheetList]('Excel File') L
		WHERE
			L.DITaskKey = @DITaskKey;

	END TRY

	BEGIN CATCH

		THROW;

	END CATCH

END

GO

