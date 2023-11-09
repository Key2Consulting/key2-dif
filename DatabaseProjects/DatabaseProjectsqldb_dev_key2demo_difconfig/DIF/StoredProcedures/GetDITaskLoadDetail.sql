

CREATE   PROCEDURE [DIF].[GetDITaskLoadDetail]
	(
	@DITaskKey varchar(50)
	)
AS

/*

SP Name:  [DIF].[GetDITaskLoadDetail]
Purpose:  Used to get load details for a given data integration task
Parameters:
     @DITaskKey - the key for a given data integration task

Test harnass:

SELECT * FROM [DIF].[SystemDetail]
SELECT * FROM [DIF].[RepositoryDetail]
SELECT * FROM [DIF].[DatasetDetail]
SELECT * FROM [DIF].[DITaskDetail]

EXEC [DIF].[GetDITaskLoadDetail]
	@DITaskKey = 11

*/

BEGIN

DECLARE
	@DITaskKeyCheck INT;

BEGIN TRY

SELECT
	@DITaskKeyCheck = a.[DITaskKey]
FROM
	[DIF].[DITaskDetail] AS a
WHERE
	a.[DITaskKey] = @DITaskKey;

IF @DITaskKeyCheck IS NULL
	THROW 50101, 'An unknown data integration task was identified by the @DITaskKey parameter.', 1;

SELECT
	a.[SourceSystemFQDN]
	,a.[SourceSystemUserName]
	,a.[SourceSystemSecretName]
	,a.[SourceRepositoryName]
	,a.[SourceDatasetNameSpace]
	,a.[SourceDatasetName]
	,a.[SourceDatasetPath]
	,a.[SourcePartitionType]
	,a.[DestinationSystemFQDN]
	,a.[DestinationSystemUserName]
	,a.[DestinationSystemSecretName]
	,a.[DestinationRepositoryName]
	,a.[DestinationDatasetNameSpace]
	,a.[DestinationDatasetName]
	,a.[DestinationDatasetPath]
	,a.[LoadType]
	,a.[DITaskSourceFilterLogic]
	,a.[DITaskWaterMarkLogic]
	,a.[DITaskMaxWaterMark]
FROM
	[DIF].[DITaskDetail] AS a
WHERE
	a.[DITaskKey] = @DITaskKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

