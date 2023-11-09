


CREATE   PROCEDURE [DIF].[EndPipelineRun]
	(
	@PipelineFullName VARCHAR(255)
	,@PipelineRunID VARCHAR(255)
	,@PipelineStatus VARCHAR(50)
	)
AS

/*

SP Name:  [DIF].[EndPipelineRun]
Purpose:  Used to end logging for a pipeline run
Parameters:
	@PipelineFullName - the full name of the pipeline that is being executed
	@PipelineRunID - the execution identifier of the pipeline being executed
	@PipelineStatus - the status value to log as the final status of the pipeline

Test harnass:

SELECT * FROM [config].[Pipeline];
SELECT * FROM [reference].[PipelineStatus]
SELECT * FROM [logging].[PipelineRun];

EXEC [DIF].[EndPipelineRun] 
	@PipelineFullName = 'PL_DIF_SQLServer_TableCopy'
	,@PipelineRunID = '62b7874d-feec-482f-85bb-f90b0dc21106'
	,@PipelineStatus = 'Failed'

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
	a.[PipelineStatus] = @PipelineStatus;

IF @PipelineStatusKey IS NULL
	THROW 50102, 'An unknown pipeline execution status was identified by the @PipelineStatus parameter.', 1;

SELECT
	@PipelineRunKey = a.[PipelineRunKey]
FROM
	[logging].[PipelineRun] AS a
WHERE
	[PipelineKey] = @PipelineKey
	AND [PipelineRunID] = @PipelineRunID;

IF @PipelineRunKey IS NULL
	THROW 50103, 'The pipeline execution ID specified by the @PipelineRunID parameter has not yet been logged for the pipeline specified by the @PipelineFullName parameter.', 1;

UPDATE
	[logging].[PipelineRun]
SET
	[PipelineRunStatusKey] = @PipelineStatusKey
	,[PipelineRunEndDateTime] = GETUTCDATE()
WHERE
	[PipelineRunKey] = @PipelineRunKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

