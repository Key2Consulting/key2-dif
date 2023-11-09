
CREATE   PROCEDURE [DIF].[UpdateDITask]
	(
	 @DITaskKey SMALLINT
	,@SourceDatasetKey SMALLINT
	,@DestinationDatasetKey SMALLINT
	,@LoadType VARCHAR(50)
	,@DITaskSourceFilterLogic VARCHAR(255) = NULL
	,@DITaskWaterMarkLogic VARCHAR(255) = NULL
	,@DITaskEnabled BIT = 1
	,@SourceFilterLogicIsEnabled BIT = 0
	,@SourceOverrideQuery VARCHAR(2000) = NULL
	,@NotebookPath VARCHAR(255) = NULL
	)
AS

/*

SP Name:  [DIF].[UpdateDITask]
Purpose:  Used to update a DIF DITask record
Parameters:
	@SourceDatasetKey - key value for the source dataset
	@DestinationDatasetKey - key value for the destinatino dataset
	@LoadType - identifies the LoadType record
	@DITaskSourceFilterLogic - Used to filter the source dataset.  Example "and City = 'Atlanta'" (optional)
	@DITaskWaterMarkLogic - Used to execute incremental extracts from the source dataset. Example "and ETLEditDate > %MinWaterMark% and ETLEditDate <= %MaxWaterMark%" (optional)
	@DITaskEnabled - Defaults to 1
	@SourceFilterLogicIsEnabled - Determines if the SourceFilterLogic is active or not.  Defaults to 0
	@SourceOverrideQuery - Optional parameter that will override the source configurations with a designated query.
	@NotebookPath - Optional parameter that specifies the location of the Databricks notebook.

Test harnass:

SELECT * FROM [metadata].[Dataset]
SELECT * FROM [reference].[LoadType]
SELECT * FROM [config].[DITask]

EXEC [DIF].[UpdateDITask]
	 @DITaskKey = 20
	,@SourceDatasetKey = 48
	,@DestinationDatasetKey = 49
	,@LoadType = 'Incremental'
	,@DITaskSourceFilterLogic = NULL
	,@DITaskWaterMarkLogic = null
	,@DITaskEnabled = 1
	,@SourceFilterLogicIsEnabled = 0--1
	,@SourceOverrideQuery = NULL
	,@NotebookPath = NULL

*/

BEGIN

DECLARE
	@LoadTypeKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the parameters are populated
*************************************************************************************************/
IF (@DITaskKey IS NULL OR @SourceDatasetKey IS NULL OR @DestinationDatasetKey IS NULL OR @LoadType IS NULL)
	THROW 50101, 'The @DITaskKey, @SourceDatasetKey, @DestinationDatasetKey and @LoadType parameters must be specified.', 1;


/*************************************************************************************************
Check for the @LoadTypeKey value
*************************************************************************************************/
SELECT
	@LoadTypeKey = LoadTypeKey
FROM
	[reference].LoadType
WHERE
	LoadType = @LoadType

IF @LoadTypeKey IS NULL
	THROW 50105, 'An unknown LoadType was identified by the @LoadTypeKey parameter.', 1;

/*************************************************************************************************
Check for the @SourceDatasetKey value
*************************************************************************************************/
IF not exists(select DatasetKey from [metadata].Dataset where DatasetKey = @SourceDatasetKey)
	THROW 50105, 'An unknown Dataset was identified by the @SourceDatasetKey parameter.', 1;

/*************************************************************************************************
Check for the @DestinationDatasetKey value
*************************************************************************************************/
IF not exists(select DatasetKey from [metadata].Dataset where DatasetKey = @DestinationDatasetKey)
	THROW 50105, 'An unknown Dataset was identified by the @DestinationDatasetKey parameter.', 1;

/*************************************************************************************************
Check to verify that the DITask provided doesn't already exist
*************************************************************************************************/
IF exists(SELECT DITaskKey FROM	[config].DITask WHERE SourceDatasetKey = @SourceDatasetKey AND DestinationDatasetKey = @DestinationDatasetKey AND LoadTypeKey = @LoadTypeKey and DITaskKey <> @DITaskKey)
	THROW 50102, 'The provided DITask values already exists in the [config].DITask table for the given datasets.', 1;

/*************************************************************************************************
Update [config].DITask record
*************************************************************************************************/
	BEGIN TRAN;

		UPDATE [config].DITask
		SET SourceDatasetKey = @SourceDatasetKey
			,DestinationDatasetKey = @DestinationDatasetKey
			,LoadTypeKey = @LoadTypeKey
			,DITaskSourceFilterLogic = isNull(@DITaskSourceFilterLogic,DITaskSourceFilterLogic)
			,DITaskWaterMarkLogic = isNull(@DITaskWaterMarkLogic,DITaskWaterMarkLogic)
			,DITaskIsEnabled = @DITaskEnabled
			,SourceFilterLogicIsEnabled = @SourceFilterLogicIsEnabled
			,SourceOverrideQuery = @SourceOverrideQuery
			,NotebookPath = @NotebookPath
			,ModifiedBy = suser_sname()
			,ModifiedDateTime = getutcdate()
		WHERE DITaskKey = @DITaskKey;

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

