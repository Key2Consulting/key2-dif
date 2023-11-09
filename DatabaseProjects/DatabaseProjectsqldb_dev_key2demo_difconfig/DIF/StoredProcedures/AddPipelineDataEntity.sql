
CREATE PROCEDURE [DIF].[AddPipelineDataEntity]
(
	@PipelineFullName VARCHAR(255) 
	, @PipelineRunID VARCHAR(255) 
	, @DataEntityName VARCHAR(255) 
	, @InsertCount BIGINT
	, @UpdateCount BIGINT
	, @DeleteCount BIGINT
	, @Comment VARCHAR(255)
)
AS
BEGIN

/*
SP Name:  DIF.AddPipelineDataEntity

Purpose:  Used to add an entry into the logging.PipelineDataEntity table to track the table counts loaded during execution of a given pipeline task

Parameters:
	@PipelineFullName - Name of the pipeline from the @pipeline.Pipeline variable
	@PipelineRunID - Execution ID of the pipeline from the @pipeline.RunId variable
	@DataEntityName - Name of the table loaded
	@InsertCount - DateTime the activity started from the @activity('<ActivityName>').ExecutionStartTime variable
	@UpdateCount - DateTime the activity ended from the @activity('<ActivityName>').ExecutionEndTime variable
	@DeleteCount - Type of activity, ie For Each
	@Comment - optional comment

Test harnass:

EXEC DIF.AddPipelineDataEntity
	@PipelineFullName VARCHAR(255) = 'PL_DIF_SQLServer_TableCopy'
	, @PipelineRunID VARCHAR(255) = '67b8f8a3-47bb-4fe4-8bcb-461a4f5a9dce'
	, @DataEntityName VARCHAR(255) = 'dim_actiontype'
	, @InsertCount BIGINT
	, @UpdateCount BIGINT
	, @DeleteCount BIGINT
;

EXEC DIF.AddPipelineDataEntity 'PL_DIF_SQLServer_TableCopy', '67b8f8a3-47bb-4fe4-8bcb-461a4f5a9dce', 'dim_actiontype', 1 , NULL, NULL, NULL

*/

DECLARE
	@PipelineKey SMALLINT
	,@PipelineRunKey INT
	,@PipelineActivityKey INT;

BEGIN TRY

SELECT
	@PipelineKey = a.PipelineKey
FROM
	config.Pipeline AS a
WHERE
	a.PipelineFullName = @PipelineFullName;

IF @PipelineKey IS NULL
	THROW 50101, 'An unknown pipeline was identified by the @PipelineFullName parameter.', 1;

SELECT
	@PipelineRunKey = a.PipelineRunKey
FROM
	logging.PipelineRun AS a
WHERE
	PipelineKey = @PipelineKey
	and PipelineRunID = @PipelineRunID;

IF @PipelineRunKey IS NULL
	THROW 50103, 'The pipeline execution ID specified by the @PipelineRunID parameter has not been logged for the pipeline specified by the @PipelineFullName parameter.', 1;


/*
SELECT
	@PipelineActivityKey = a.PipelineActivityKey
FROM
	logging.PipelineActivity AS a
WHERE
	a.PipelineRunKey = @PipelineRunKey
	and a.PipelineActivityRunID = @PipelineActivityRunID;


IF @PipelineActivityKey IS NULL
	THROW 50106, 'The pipeline activity execution ID specified by the @PipelineActivityRunID parameter has not been logged for the pipeline specified by the @PipelineFullName parameter and the pipeline execution ID specified by the @PipelineRunID parameter.', 1;
*/

INSERT INTO logging.PipelineDataEntity
	(

		PipelineRunKey
		, DataEntityName
		, InsertCount
		, UpdateCount
		, DeleteCount
		, Comment
	)
VALUES
	(		
		@PipelineRunKey
		, @DataEntityName
		, @InsertCount
		, @UpdateCount
		, @DeleteCount
		, @Comment
	)
;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

