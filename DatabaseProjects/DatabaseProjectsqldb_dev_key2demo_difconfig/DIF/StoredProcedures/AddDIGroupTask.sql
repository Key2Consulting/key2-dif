



CREATE     PROCEDURE [DIF].[AddDIGroupTask]
	(
	 @DIGroupKey SMALLINT
	,@DITaskKey INT
	,@DIGroupTaskPriorityOrder SMALLINT = 1
	,@PipelineKey SMALLINT
	,@RelatedDIGroupTaskKey INT
	)
AS

/*

SP Name:  [DIF].[AddDIGroupTask]
Purpose:  Used to add a new DIF DIGroupTask
Parameters:
	@DIGroupKey - key value for the given DIGroup
	@DITaskKey - key value for the given DITask
	@DIGroupTaskPriorityOrder - Sets the order and precedence of the various tasks in a given DIGroup.  Example, if you want to ingest dimension table first, give those all a value of 1.  Fact tables would then get 2.
	@PipelineKey - key value for the given pipeline for this DITask
	@RelatedDIGroupTaskKey - key for the related DIGroupTask record.  This only used if the related task should be kicked off immediately following the completion of the current task.

Test harnass:

SELECT * FROM [config].[DIGroup]
SELECT * FROM [config].[DITask]
SELECT * FROM [config].[Pipeline]
SELECT * FROM [config].[DIGroupTask]

EXEC [DIF].[AddDIGroupTask]
	@DIGroupKey = 12
	,@DITaskKey = 28
	,@DIGroupTaskPriorityOrder = 1
	,@PipelineKey = 11
	,@RelatedDIGroupTaskKey = 22

*/

BEGIN

DECLARE
	@DIGroupTaskKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the required parameters are populated
*************************************************************************************************/
IF (@DIGroupKey IS NULL OR @DITaskKey IS NULL or @PipelineKey IS NULL)
	THROW 50101, 'The @DIGroupKey, @PipelineKey and @DITaskKey parameters must be specified.', 1;

/*************************************************************************************************
Check for the @DIGroupKey value
*************************************************************************************************/
IF not exists (select DIGroupKey from [config].DIGroup where DIGroupKey = @DIGroupKey)
	THROW 50105, 'An unknown DIGroup was identified by the @DIGroupKey parameter.', 1;

/*************************************************************************************************
Check for the @PipelineKey value
*************************************************************************************************/
IF not exists (select PipelineKey from [config].Pipeline where PipelineKey = @PipelineKey)
	THROW 50105, 'An unknown Pipeline was identified by the @PipelineKey parameter.', 1;

/*************************************************************************************************
Check for the @DITaskKey value
*************************************************************************************************/
IF not exists (select DITaskKey from [config].DITask where DITaskKey = @DITaskKey)
	THROW 50105, 'An unknown DITask was identified by the @DITaskKey parameter.', 1;

/*************************************************************************************************
Check for the @RelatedDIGroupTaskKey value
*************************************************************************************************/
IF not exists (select DIGroupTaskKey from [config].DIGroupTask where DIGroupTaskKey = @RelatedDIGroupTaskKey) AND @RelatedDIGroupTaskKey IS NOT NULL
	THROW 50105, 'An unknown DIGroupTask was identified by the @RelatedDIGroupTaskKey parameter.', 1;

/*************************************************************************************************
Check to verify that the DIGroupTask provided doesn't already exist
*************************************************************************************************/
SELECT
	@DIGroupTaskKey = DIGroupTaskKey
FROM
	[config].DIGroupTask
WHERE
	DIGroupKey = @DIGroupKey
	AND DITaskKey = @DITaskKey

IF @DIGroupTaskKey IS NOT NULL
	THROW 50102, 'The provided DIGroupTask values already exists in the [config].DIGroupTask table.  Please use the DIF.UpdateDIGroupTask store procedure to update any values in that table.', 1;


/*************************************************************************************************
Add new [config].DIGroupTask record
*************************************************************************************************/
	BEGIN TRAN;

		INSERT INTO [config].[DIGroupTask]
			(
			 [DIGroupKey]
			 , [DITaskKey]
			 , [DIGroupTaskPriorityOrder]
			 , [CreatedBy]
			 , [CreatedDateTime]
			 , [ModifiedBy]
			 , [ModifiedDateTime]
			 , [PipelineKey]
			 , [RelatedDIGroupTaskKey]
			)
		VALUES
			(
			@DIGroupKey
			,@DITaskKey
			,@DIGroupTaskPriorityOrder
			,suser_sname()
			,getutcdate()
			,suser_sname()
			,getutcdate()
			,@PipelineKey
			,@RelatedDIGroupTaskKey
			);

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

