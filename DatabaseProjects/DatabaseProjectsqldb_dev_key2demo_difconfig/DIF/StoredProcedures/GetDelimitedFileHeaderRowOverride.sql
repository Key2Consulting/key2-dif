




CREATE PROCEDURE [DIF].[GetDelimitedFileHeaderRowOverride]
(
	@DITaskKey INT
	
)
AS

/*

SP Name:  [DIF].[GetDelimitedFileHeaderRowOverride]
Purpose:  
Parameters:
     @DITaskKey - the key for a given data integration task



EXEC [DIF].[GetDelimitedFileHeaderRowOverride]
	@DITaskKey = 6


*/

BEGIN

	DECLARE	@TestDIGroupTaskKey INT;	
	DECLARE @SourceDelimitedFileKey INT;
	DECLARE @DelimitiedFileHeaderSQL VARCHAR(MAX) = '';


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
			@SourceDelimitedFileKey = L.SourceDelimitedFileKey
		FROM 
			[DIF].[udf_GetDITaskDelimitedFileList]('Delimited Text File') L
		WHERE
			L.DITaskKey = @DITaskKey
			AND L.SourceDelimitedFileIsHeaderRowOverride = 1;

		IF @SourceDelimitedFileKey IS NULL
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
			@DelimitiedFileHeaderSQL = 'SELECT ' + REPLACE(SourceHeaderCDS, ',', ' = '''', ') + ' = '''' FROM [sys].[tables] WHERE 1 = 0;'
		FROM 
			CTE_HeaderCDS;

		-------SELECT @DelimitiedFileHeaderSQL

		EXEC(@DelimitiedFileHeaderSQL);

	END TRY

	BEGIN CATCH

		THROW;

	END CATCH

END

GO

