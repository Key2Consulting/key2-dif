


CREATE   PROCEDURE [DIF].[GetDIGroupTaskPriorityOrder]
	(
	@ProjectName VARCHAR(50)
	,@DIGroupName VARCHAR(50)
	)
AS

/*

SP Name:  [DIF].[GetDIGroupTaskPriorityOrder]
Purpose:  Used to get the load queries and file name info for a given task.  It builds the source query that will be passed to the copy operation.
Parameters:
     @ProjectName - Name of the project associated with the given pipeline and DIGroup
	 @DIGroupName - DIGroup name that will determine the specific tasks run by the pipeline

Test harness:

select * from [config].DIGroupTask
select * from [config].DITask
select * from [config].DIGroup
select * from [config].Pipeline
select * from [config].Project

EXEC [DIF].[GetDIGroupTaskPriorityOrder]
	@ProjectName = 'Test SQL Server Ingestion Framework'
	,@DIGroupName = 'Test Group Incremental'

*/

BEGIN

DECLARE
	@DIGroupKey INT
	,@ProjectKey INT

BEGIN TRY

--Check to see that the DIGroupName parameter matches a config record
SELECT
	@DIGroupKey = a.DIGroupKey
FROM
	[config].DIGroup AS a
WHERE
	a.DIGroupName = @DIGroupName;

IF @DIGroupKey IS NULL
	THROW 50101, 'An unknown DIGroup value was identified by the @DIGroupName parameter.', 1;

--Check to see that the ProjectName parameter matches a config record
SELECT
	@ProjectKey = a.ProjectKey
FROM
	[config].Project AS a
WHERE
	a.ProjectName = @ProjectName;

IF @ProjectKey IS NULL
	THROW 50101, 'An unknown Project value was identified by the @ProjectName parameter.', 1;



SELECT DISTINCT 
		DGT.DIGroupKey
		,DGT.DIGroupTaskPriorityOrder
FROM [config].DIGroup DG
	INNER JOIN [config].DIGroupTask DGT
		on DG.DIGroupKey = DGT.DIGroupKey
	INNER JOIN [config].Pipeline pl
		ON DGT.PipelineKey = pl.PipelineKey
	INNER JOIN [config].Project prj
		ON pl.ProjectKey = prj.ProjectKey
WHERE DG.DIGroupKey = @DIGroupKey
AND prj.ProjectKey = @ProjectKey
AND DGT.DIGroupTaskPriorityOrder > 0
ORDER BY DGT.DIGroupTaskPriorityOrder

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

