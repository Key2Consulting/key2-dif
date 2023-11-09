


CREATE    PROCEDURE [DIF].[AddPipelineResultMultiple]
	(
	@PipelineRunID VARCHAR(255)
	,@PipelineActivityRunID VARCHAR(255)
	,@PipelineResult VARCHAR(max)
	)
AS

/*

SP Name:  [DIF].[AddPipelineResultMultiple]
Purpose:  Used to add an entry into the DIF.PipelineResult table to track execution values from a given pipeline task
Parameters:
	@PipelineRunID - Execution ID of the pipeline from the @pipeline.RunId variable
	@PipelineActivityRunID - Execution ID of the activity task from the @activity('<ActivityName>').ActivityRunId variable
	@PipelineResult - Separate string that passes in multiple PipelineResultName/PipelineResult values.  Combinations are separated by a ";" Example 'SinkPath|dw/db/db.dbo.table/full/2021/12/01;RowsCopied|10765'

Test harnass:

SELECT * FROM [config].[DITask]
SELECT * FROM [config].[Pipeline]
SELECT * FROM [logging].[PipelineRun]
SELECT * FROM [logging].[PipelineActivity]
SELECT * FROM [reference].[PipelineResultName]
SELECT * FROM [logging].[PipelineResult]



EXEC [DIF].[AddPipelineResultMultiple]
	@PipelineRunID  = '0ddd0044-6ca4-4777-8fe5-0b215cc202ec'
	,@PipelineActivityRunID  = 'd4126272-cd04-4c03-a396-a607a38ea7d9'
	,@PipelineResult = 'SinkPath|dw/db/db.dbo.table/full/2021/12/01;RowsCopied|10765'


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


INSERT INTO [logging].[PipelineResult]
	(
	[PipelineRunKey]
	, [PipelineActivityKey]
	, [PipelineResultNameKey]
	, [PipelineResultValue]
	)
select @PipelineRunKey
		,@PipelineActivityKey
		,rn.PipelineResultNameKey
		,ss.PipelineResultValue
from (
		select value
				,LEFT(value,charindex('|',value)-1) as PipelineResultName
				,SUBSTRING(value,CHARINDEX('|',value)+1,LEN(value)) as PipelineResultValue
		from string_split(@PipelineResult,';')
		)ss
	left outer join [reference].PipelineResultName rn
		on ss.PipelineResultName = rn.PipelineResultName;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

