
CREATE     PROCEDURE [DIF].[UpdateDIGroupTask]
	(
	 @DIGroupTaskKey INT
	,@DIGroupKey SMALLINT
	,@DITaskKey INT
	,@DIGroupTaskPriorityOrder SMALLINT = 1
	,@PipelineKey SMALLINT
	,@RelatedDIGroupTaskKey INT
	)
AS

/*

SP Name:  [DIF].[UpdateDIGroupTask]
Purpose:  Used to update a DIF DIGroupTask record
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

EXEC [DIF].[UpdateDIGroupTask]
	@DIGroupTaskKey = 25
	,@DIGroupKey = 12
	,@DITaskKey = 28
	,@DIGroupTaskPriorityOrder = 2
	,@PipelineKey = 11
	,@RelatedDIGroupTaskKey = null

*/

BEGIN


BEGIN TRY

/*************************************************************************************************
Check to see if the required parameters are populated
*************************************************************************************************/
IF (@DIGroupTaskKey IS NULL OR @DIGroupKey IS NULL OR @DITaskKey IS NULL or @PipelineKey IS NULL)
	THROW 50101, 'The @DIGroupTaskKey, @DIGroupKey, @PipelineKey and @DITaskKey parameters must be specified.', 1;

/*************************************************************************************************
Check for the @DIGroupKey value
*************************************************************************************************/
IF not exists (select DIGroupKey from [config].DIGroup where DIGroupKey = @DIGroupKey)
	THROW 50105, 'An unknown DIGroup was identified by the @DIGroupKey parameter.', 1;

/*************************************************************************************************
Check for the @DITaskKey value
*************************************************************************************************/
IF not exists (select DITaskKey from [config].DITask where DITaskKey = @DITaskKey)
	THROW 50105, 'An unknown DITask was identified by the @DITaskKey parameter.', 1;

/*************************************************************************************************
Check for the @PipelineKey value
*************************************************************************************************/
IF not exists (select PipelineKey from [config].Pipeline where PipelineKey = @PipelineKey)
	THROW 50105, 'An unknown Pipeline was identified by the @PipelineKey parameter.', 1;

/*************************************************************************************************
Check to verify that the DIGroupTask provided doesn't already exist
*************************************************************************************************/
IF exists (select DIGroupTaskKey from [config].DIGroupTask where DIGroupKey = @DIGroupKey and DITaskKey = @DITaskKey and DIGroupTaskKey <> @DIGroupTaskKey)
	THROW 50102, 'The provided DIGroupTask values already exists in the [config].DIGroupTask table.', 1;

/*************************************************************************************************
Check for the @RelatedDIGroupTaskKey value
*************************************************************************************************/
IF not exists (select DIGroupTaskKey from [config].DIGroupTask where DIGroupTaskKey = @RelatedDIGroupTaskKey) and @RelatedDIGroupTaskKey IS NOT NULL
	THROW 50105, 'An unknown DIGroupTask was identified by the @RelatedDIGroupTaskKey parameter.', 1;

/*************************************************************************************************
Update [config].DIGroupTask record
*************************************************************************************************/
	BEGIN TRAN;

		Update [config].[DIGroupTask]
		SET DIGroupKey = @DIGroupKey
			,DITaskKey = @DITaskKey
			,DIGroupTaskPriorityOrder = @DIGroupTaskPriorityOrder
			,ModifiedBy = suser_sname()
			,ModifiedDateTime = getutcdate()
			,PipelineKey = @PipelineKey
			,RelatedDIGroupTaskKey = @RelatedDIGroupTaskKey
		WHERE DIGroupTaskKey = @DIGroupTaskKey;

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

