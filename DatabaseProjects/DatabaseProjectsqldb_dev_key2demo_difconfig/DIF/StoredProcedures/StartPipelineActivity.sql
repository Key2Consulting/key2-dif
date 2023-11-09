
CREATE   PROCEDURE [DIF].[StartPipelineActivity]
	(
	@PipelineFullName VARCHAR(255)
	,@PipelineRunID VARCHAR(255)
	,@PipelineActivityRunID VARCHAR(255)
	,@PipelineActivityName VARCHAR(255)
	,@PipelineActivityType VARCHAR(255) = NULL
	,@DITaskKey INT = NULL
	)
AS

/*

SP Name:  [DIF].[StartPipelineActivity]
Purpose:  Used to start logging for a pipeline activity run
Parameters:
	@PipelineFullName - the full name of the pipeline that is being executed
	@PipelineRunID - the execution identifier of the pipeline being executed
	@PipelineActivityRunID - the execution identifier for the pipeline activity being executed
	@PipelineActivityName - the name of the pipeline activity being executed
	@PipelineActivityType - the type of the pipeline activity being executed; this parameter is not required
	@DITaskKey - the key for the DITask that the pipeline activity is being executed on behalf of (typically a Copy Data activity); this parameter is not required

Test harnass:

SELECT * FROM [config].[Pipeline];
SELECT * FROM [reference].[PipelineStatus]
SELECT * FROM [config].[DITask]
SELECT * FROM [logging].[PipelineRun]
SELECT * FROM [logging].[PipelineActivity];

EXEC [DIF].[StartPipelineActivity]
	@PipelineFullName = 'PL_DIF_SQLServer_TableCopy'
	,@PipelineRunID = '62b7874d-feec-482f-85bb-f90b0dc21106'
	,@PipelineActivityRunID = '27a86cfb-5413-48d5-9079-3ff8c01678c4'
	,@PipelineActivityName = 'Copy_SQL_Data'
	,@PipelineActivityType = 'Copy data'
	,@DITaskKey = 1;

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
	a.[PipelineStatus] = 'InProgress';

IF @PipelineStatusKey IS NULL
	THROW 50102, 'The entry for the "InProgress" status in the [reference].PipelineStatus table appears to be missing.', 1;

SELECT
	@PipelineRunKey = a.[PipelineRunKey]
	,@PipelineRunStatusKey = a.[PipelineRunStatusKey]
FROM
	[logging].[PipelineRun] AS a
WHERE
	[PipelineKey] = @PipelineKey
	and [PipelineRunID] = @PipelineRunID;

IF @PipelineRunKey IS NULL
	THROW 50103, 'The pipeline execution ID specified by the @PipelineRunID parameter has not been logged for the pipeline specified by the @PipelineFullName parameter.', 1;

IF @PipelineRunStatusKey <> @PipelineStatusKey
	THROW 50104, 'Logging has ended for the pipeline execution ID specified by the @PipelineRunID parameter and the pipeline specified by the @PipelineFullName parameter.', 1;

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
	)
VALUES
	(
	@PipelineRunKey
	,@PipelineStatusKey
	,@DITaskKey
	,@PipelineActivityRunID
	,@PipelineActivityName
	,@PipelineActivityType
	,GETUTCDATE()
	);

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

