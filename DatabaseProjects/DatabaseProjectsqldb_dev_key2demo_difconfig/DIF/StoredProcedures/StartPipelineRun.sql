

CREATE   PROCEDURE [DIF].[StartPipelineRun]
	(
	@PipelineFullName VARCHAR(255)
	,@PipelineRunID VARCHAR(255)
	)
AS

/*

SP Name:  [DIF].[StartPipelineRun]
Purpose:  Used to start logging for a pipeline run
Parameters:
	@PipelineFullName - the full name of the pipeline that is being executed
	@PipelineRunID - the execution identifier of the pipeline being executed

Test harnass:

SELECT * FROM [config].[Pipeline];
SELECT * FROM [reference].[PipelineStatus]
SELECT * FROM [logging].[PipelineRun];

EXEC [DIF].[StartPipelineRun]
	@PipelineFullName = 'PL_DIF_SQLServer_TableLoop'
	,@PipelineRunID = '62b7874d-feec-482f-85bb-f90b0dc21105'

*/

BEGIN

DECLARE
	@PipelineKey SMALLINT
	,@PipelineStatusKey SMALLINT
	,@PipelineRunKey INT;

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
FROM
	[logging].[PipelineRun] AS a
WHERE
	[PipelineKey] = @PipelineKey
	and [PipelineRunID] = @PipelineRunID;

IF @PipelineRunKey IS NOT NULL
	THROW 50103, 'The pipeline execution ID specified by the @PipelineRunID parameter has already been logged for the pipeline specified by the @PipelineFullName parameter.', 1;

INSERT INTO [logging].[PipelineRun]
	(
	[PipelineKey]
	,[PipelineRunStatusKey]
	,[PipelineRunID]
	,[PipelineRunStartDateTime]
	)
VALUES
	(
	@PipelineKey
	,@PipelineStatusKey
	,@PipelineRunID
	,GETUTCDATE()
	);

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

