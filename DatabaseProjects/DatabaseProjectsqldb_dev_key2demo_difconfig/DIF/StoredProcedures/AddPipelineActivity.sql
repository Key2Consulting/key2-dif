



CREATE     PROCEDURE [DIF].[AddPipelineActivity]
	(
	@PipelineFullName VARCHAR(255)
	,@PipelineRunID VARCHAR(255)
	,@PipelineActivityRunID VARCHAR(255)
	,@PipelineActivityName VARCHAR(255)
	,@PipelineActivityStartDateTime DATETIME2(0)
	,@PipelineActivityEndDateTime DATETIME2(0)
	,@PipelineActivityType VARCHAR(255) = NULL
	,@DITaskKey INT = NULL
	)
AS

/*

SP Name:  [DIF].[AddPipelineActivity]
Purpose:  Used to add an entry into the [logging].PipelineActivity table to track the execution of a given pipeline task
Parameters:
	@PipelineFullName - Name of the pipeline from the @pipeline.Pipeline variable
	@PipelineRunID - Execution ID of the pipeline from the @pipeline.RunId variable
	@PipelineActivityRunID - Execution ID of the activity task from the @activity('<ActivityName>').ActivityRunId variable
	@PipelineActivityName - Name of the activity
	@PipelineActivityStartDateTime - DateTime the activity started from the @activity('<ActivityName>').ExecutionStartTime variable
	@PipelineActivityEndDateTime - DateTime the activity ended from the @activity('<ActivityName>').ExecutionEndTime variable
	@PipelineActivityType - Type of activity, ie For Each
	@DITaskKey - DITaskKey value from the corresponding record in the config.DITask table

Test harnass:

SELECT * FROM [config].[DITask]
SELECT * FROM [config].[Pipeline]
SELECT * FROM [reference].[PipelineStatus]
SELECT * FROM [logging].[PipelineRun]
SELECT * FROM [logging].[PipelineActivity]



EXEC [DIF].[AddPipelineActivity]
	@PipelineFullName = 'PL_DIF_SQLServer_TableCopy'
	,@PipelineRunID  = '0ddd0044-6ca4-4777-8fe5-0b215cc202ec'
	,@PipelineActivityRunID  = 'd4126272-cd04-4c03-a396-a607a38ea7d9'
	,@PipelineActivityName  = 'PL_DIF_SQLServer_TableCopy.FOREACH_LoadQuery'
	,@PipelineActivityStartDateTime  = '2021-12-02 19:45:09'
	,@PipelineActivityEndDateTime  = '2021-12-02 19:45:22'
	,@PipelineActivityType = 'For Each'
	,@DITaskKey = 16



*/


BEGIN

DECLARE
	@PipelineKey SMALLINT
	,@PipelineStatusKey SMALLINT
	,@PipelineRunKey INT
	,@PipelineRunStatusKey SMALLINT
	,@DITaskKeyCheck INT
	,@PipelineActivityKey INT;

BEGIN TRY

SELECT
	@PipelineKey = a.[PipelineKey]
FROM
	[config].[Pipeline] AS a
WHERE
	a.[PipelineFullName] = @PipelineFullName;

IF @PipelineKey IS NULL
	THROW 50101, 'An unknown pipeline was identified by the @PipelineFullName parameter.', 1;

SELECT
	@PipelineStatusKey = a.[PipelineStatusKey]
FROM
	[reference].[PipelineStatus] AS a
WHERE
	a.[PipelineStatus] = 'Succeeded';

IF @PipelineStatusKey IS NULL
	THROW 50102, 'The entry for the "Succeeded" status in the [reference].PipelineStatus table appears to be missing.', 1;

SELECT
	@PipelineRunKey = a.[PipelineRunKey]
FROM
	[logging].[PipelineRun] AS a
WHERE
	[PipelineKey] = @PipelineKey
	and [PipelineRunID] = @PipelineRunID;

IF @PipelineRunKey IS NULL
	THROW 50103, 'The pipeline execution ID specified by the @PipelineRunID parameter has not been logged for the pipeline specified by the @PipelineFullName parameter.', 1;


SELECT
	@DITaskKeyCheck = a.[DITaskKey]
FROM
	[config].[DITask] AS a
WHERE
	a.[DITaskKey] = @DITaskKey;

IF @DITaskKey IS NOT NULL AND @DITaskKeyCheck IS NULL
	THROW 50105, 'The data integration task specified by the @DITaskKey parameter does not exist.', 1;

SELECT
	@PipelineActivityKey = a.[PipelineActivityKey]
FROM
	[logging].[PipelineActivity] AS a
WHERE
	a.[PipelineRunKey] = @PipelineRunKey
	and a.[PipelineActivityRunID] = @PipelineActivityRunID;

IF @PipelineActivityKey IS NOT NULL
	THROW 50106, 'The pipeline activity execution ID specified by the @PipelineActivityRunID parameter has already been logged for the pipeline specified by the @PipelineFullName parameter and the pipeline execution ID specified by the @PipelineRunID parameter.', 1;

INSERT INTO [logging].[PipelineActivity]
	(
	[PipelineRunKey]
	,[PipelineActivityStatusKey]
	,[DITaskKey]
	,[PipelineActivityRunID]
	,[PipelineActivityName]
	,[PipelineActivityType]
	,[PipelineActivityStartDateTime]
	,[PipelineActivityEndDateTime]
	)
VALUES
	(
	@PipelineRunKey
	,@PipelineStatusKey
	,@DITaskKey
	,@PipelineActivityRunID
	,@PipelineActivityName
	,@PipelineActivityType
	,@PipelineActivityStartDateTime
	,@PipelineActivityEndDateTime
	);

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

