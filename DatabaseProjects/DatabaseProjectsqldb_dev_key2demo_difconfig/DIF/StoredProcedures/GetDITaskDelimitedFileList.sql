




CREATE PROCEDURE [DIF].[GetDITaskDelimitedFileList]
(
	@DITaskKey INT
	/*@MaxWaterMark VARCHAR(255)*/  --leave commented for now to support IngestionFileName and LoadFolder attributes
)
AS

/*

SP Name:  [DIF].[GetDITaskDelimitedFileList]
Purpose:  Used to fetch delimited file to parquet task data. Assembles destination file folder and file name prefix and joins to source/destination attributes pulled from DITaskDetail
Parameters:
     @DITaskKey - the key for a given data integration task

Test harnass:

select * from [metadata].Dataset
select * from DIF.DITaskDetail

EXEC [DIF].[GetDITaskDelimitedFileList]
	@DITaskKey = 4


*/

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
			[DIF].[udf_GetDITaskDelimitedFileList]('Delimited Text File') L
		WHERE
			L.DITaskKey = @DITaskKey;

	END TRY

	BEGIN CATCH

		THROW;

	END CATCH

END

GO

