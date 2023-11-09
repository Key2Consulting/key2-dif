

CREATE   PROCEDURE [DIF].[GetDITaskList]
	(
	@ProjectName VARCHAR(50)
	,@DIGroupName VARCHAR(50)
	)
AS

/*

SP Name:  [DIF].[GetDITaskList]
Purpose:  Used to get a list of DI tasks for a given project and DI group
Parameters:
     @ProjectName - the name of the project involved
	 @DIGroupName - the name of the DI group being handled

Test harnass:

SELECT * FROM [DIF].[ProjectDetail]
SELECT * FROM [DIF].[DIGroupDetail];
SELECT * FROM [DIF].[DITaskDetail]

EXEC [DIF].[GetDITaskList]
	@ProjectName = 'Test SQL Server Ingestion Framework'
	,@DIGroupName = 'All Test Views'

*/

BEGIN

DECLARE
	@ProjectKey SMALLINT
	,@DIGroupKey SMALLINT;

BEGIN TRY

SELECT
	@ProjectKey = p.[ProjectKey]
FROM
	[DIF].[ProjectDetail] AS p
WHERE
	p.[ProjectName] = @ProjectName;

IF @ProjectKey IS NULL
	THROW 50101, 'An unknown project was identified by the @ProjectName parameter.', 1;

SELECT
	@DIGroupKey = d.[DIGroupKey]
FROM
	[DIF].[DIGroupDetail] AS d
WHERE
	d.[DIGroupName] = @DIGroupName;

IF @DIGroupKey IS NULL
	THROW 50101, 'An unknown data ingestion group was identified by the @DIGroupName parameter.', 1;

SELECT
	a.[DITaskKey]
FROM 
	[DIF].[DIGroupTaskDetail] AS a
WHERE
	a.[ProjectName] = @ProjectName
	AND a.[DIGroupName] = @DIGroupName
	AND a.[DIGroupIsEnabled] = 1
	AND a.[DITaskIsEnabled] = 1
ORDER BY
	a.[DIGroupTaskPriorityOrder];

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

