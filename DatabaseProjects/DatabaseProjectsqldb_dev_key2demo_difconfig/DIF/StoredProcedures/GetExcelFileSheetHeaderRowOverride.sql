



CREATE PROCEDURE [DIF].[GetExcelFileSheetHeaderRowOverride]
(
	@DITaskKey INT
	
)
AS

/*

SP Name:  [DIF].[GetExcelFileSheetHeaderRowOverride]
Purpose:  
Parameters:
     @DITaskKey - the key for a given data integration task



EXEC [DIF].[GetExcelFileSheetHeaderRowOverride]
	@DITaskKey = 131


*/

BEGIN

	DECLARE	@TestDIGroupTaskKey INT;	
	DECLARE @SourceExcelFileKey INT;
	DECLARE @ExcelFileSheetHeaderSQL VARCHAR(MAX) = '';


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
			@SourceExcelFileKey = L.SourceExcelFileKey
		FROM 
			[DIF].[udf_GetDITaskExcelFileSheetList]('Excel File') L
		WHERE
			L.DITaskKey = @DITaskKey
			AND L.SourceExcelFileSheetIsHeaderRowOverride = 1;

		IF @SourceExcelFileKey IS NULL
			THROW 50101, 'Header override configurations not found for supplied @DITaskKey parameter', 1;

		
		WITH CTE_HeaderCDS AS
		(
			SELECT 
				A.DatasetKey,
				SourceHeaderCDS = STRING_AGG(QUOTENAME(AttributeName), ',') WITHIN GROUP (ORDER BY A.AttributeSequenceNumber ASC) 
			FROM 
				[metadata].[Attribute] A
				INNER JOIN [DIF].[DITaskDetail] TD
					ON TD.SourceDatasetKey = A.DatasetKey
			WHERE
				TD.DITaskKey = @DITaskKey
			GROUP BY
				A.DatasetKey
			)

		SELECT
			@ExcelFileSheetHeaderSQL = 'SELECT ' + REPLACE(SourceHeaderCDS, ',', ' = '''', ') + ' = '''' FROM [sys].[tables] WHERE 1 = 0;'
		FROM 
			CTE_HeaderCDS;

		-------SELECT @ExcelFileSheetHeaderSQL

		EXEC(@ExcelFileSheetHeaderSQL);

	END TRY

	BEGIN CATCH

		THROW;

	END CATCH

END

GO

