


CREATE     PROCEDURE [DIF].[AddPipelineResult]
	(
	@PipelineRunID VARCHAR(255)
	,@PipelineActivityRunID VARCHAR(255)
	,@PipelineResultName VARCHAR(255)
	,@PipelineResult VARCHAR(255) = NULL
	)
AS

/*

SP Name:  [DIF].[AddPipelineResult]
Purpose:  Used to add an entry into the [logging].PipelineResult table to track execution values from a given pipeline task
Parameters:
	@PipelineRunID - Execution ID of the pipeline from the @pipeline.RunId variable
	@PipelineActivityRunID - Execution ID of the activity task from the @activity('<ActivityName>').ActivityRunId variable
	@PipelineResultName - Name value from the DIF.PipelineResultName table
	@PipelineResult - Result value from a given pipeline activity

Test harnass:

SELECT * FROM [config].[DITask]
SELECT * FROM [config].[Pipeline]
SELECT * FROM [logging].[PipelineRun]
SELECT * FROM [logging].[PipelineActivity]
SELECT * FROM [reference].[PipelineResultName]
SELECT * FROM [logging].[PipelineResult]



EXEC [DIF].[AddPipelineResult]
	@PipelineRunID  = '0ddd0044-6ca4-4777-8fe5-0b215cc202ec'
	,@PipelineActivityRunID  = 'd4126272-cd04-4c03-a396-a607a38ea7d9'
	,@PipelineResultName  = 'SinkPath'
	,@PipelineResult = 'dw/db1/db1.dbo.table/full/2021/12/01'


*/


BEGIN

DECLARE
	@PipelineRunKey INT
	,@PipelineResultNameKey SMALLINT
	,@PipelineActivityKey INT;

BEGIN TRY


SELECT
	@PipelineRunKey = a.[PipelineRunKey]
FROM
	[logging].[PipelineRun] AS a
WHERE
	[PipelineRunID] = @PipelineRunID;

IF @PipelineRunKey IS NULL
	THROW 50103, 'The pipeline execution ID specified by the @PipelineRunID parameter has not been logged for the pipeline.', 1;

SELECT
	@PipelineActivityKey = a.[PipelineActivityKey]
FROM
	[logging].[PipelineActivity] AS a
WHERE
	a.[PipelineRunKey] = @PipelineRunKey
	and a.[PipelineActivityRunID] = @PipelineActivityRunID;

IF @PipelineActivityKey IS NULL
	THROW 50106, 'The pipeline activity execution ID specified by the @PipelineActivityRunID parameter does not exist for pipeline execution ID specified by the @PipelineRunID parameter.', 1;

SELECT
	@PipelineResultNameKey = a.PipelineResultNameKey
FROM
	[reference].[PipelineResultName] AS a
WHERE
	a.PipelineResultName = @PipelineResultName;

IF @PipelineResultNameKey IS NULL
	THROW 50106, 'The pipeline result name value specified by the @PipelineResultName parameter does not exist in the reference.PipelineResultName table.', 1;


INSERT INTO [logging].[PipelineResult]
	(
	[PipelineRunKey]
	, [PipelineActivityKey]
	, [PipelineResultNameKey]
	, [PipelineResultValue]
	)
VALUES
	(
	@PipelineRunKey
	,@PipelineActivityKey
	,@PipelineResultNameKey
	,@PipelineResult
	);

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

