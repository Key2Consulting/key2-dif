



CREATE     PROCEDURE [DIF].[AddDITask]
	(
	 @SourceDatasetKey SMALLINT
	,@DestinationDatasetKey SMALLINT
	,@LoadType VARCHAR(50)
	,@DITaskSourceFilterLogic VARCHAR(255)
	,@DITaskWaterMarkLogic VARCHAR(255)
	,@DITaskEnabled BIT = 1
	,@SourceFilterLogicIsEnabled BIT = 0
	,@DITask INT OUTPUT
	)
AS

/*

SP Name:  [DIF].[DIDITask]
Purpose:  Used to add a new DIF DITask
Parameters:
	@SourceDatasetKey - key value for the source dataset
	@DestinationDatasetKey - key value for the destinatino dataset
	@LoadType - identifies the LoadType record
	@DITaskSourceFilterLogic - Used to filter the source dataset.  Example "and KEY in (1,2)" (optional)
	@DITaskWaterMarkLogic - Used to execute incremental extracts from the source dataset. Example "and ETLEditDate > %MinWaterMark% and ETLEditDate <= %MaxWaterMark%" (optional)
	@DITaskEnabled - Defaults to 1
	@SourceFilterLogicIsEnabled - Determines if the SourceFilterLogic is active or not.  Defaults to 0

Test harnass:

SELECT * FROM [metadata].[Dataset]
SELECT * FROM [reference].[LoadType]
SELECT * FROM [config].[DITask]

DECLARE @DK INT

EXEC [DIF].[AddDITask]
	@SourceDatasetKey = 48
	,@DestinationDatasetKey = 49
	,@LoadType = 'Full Only'
	,@DITaskSourceFilterLogic = 'AND KEY in (678,123)'
	,@DITaskWaterMarkLogic = null
	,@DITaskEnabled = 1
	,@SourceFilterLogicIsEnabled = 1
	,@DITask = @DK OUTPUT

SELECT @DK

*/

BEGIN

DECLARE
	@DITaskCheckKey INT
	,@LoadTypeKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the required parameters are populated
*************************************************************************************************/
IF (@SourceDatasetKey IS NULL OR @DestinationDatasetKey IS NULL OR @LoadType IS NULL)
	THROW 50101, 'The @SourceDatasetKey, @DestinationDatasetKey and @LoadType parameters must be specified.', 1;

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
SELECT
	@DITaskCheckKey = DITaskKey
FROM
	[config].DITask
WHERE
	SourceDatasetKey = @SourceDatasetKey
	AND DestinationDatasetKey = @DestinationDatasetKey
	AND LoadTypeKey = @LoadTypeKey

IF @DITaskCheckKey IS NOT NULL
	THROW 50102, 'The provided DITask values already exists in the [config].DITask table.  Please use the DIF.UpdateDITask store procedure to update any values in that table.', 1;


/*************************************************************************************************
Add new [config].DITask record
*************************************************************************************************/
	BEGIN TRAN;

		INSERT INTO [config].[DITask]
			(
			 [SourceDatasetKey]
			 , [DestinationDatasetKey]
			 , [LoadTypeKey]
			 , [DITaskSourceFilterLogic]
			 , [DITaskWaterMarkLogic]
			 , [DITaskIsEnabled]
			 , [CreatedBy]
			 , [CreatedDateTime]
			 , [ModifiedBy]
			 , [ModifiedDateTime]
			 , [SourceFilterLogicIsEnabled]
			)
		VALUES
			(
			@SourceDatasetKey
			,@DestinationDatasetKey
			,@LoadTypeKey
			,@DITaskSourceFilterLogic
			,@DITaskWaterMarkLogic
			,@DITaskEnabled
			,suser_sname()
			,getutcdate()
			,suser_sname()
			,getutcdate()
			,@SourceFilterLogicIsEnabled
			);

		SET @DITask = SCOPE_IDENTITY();

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

