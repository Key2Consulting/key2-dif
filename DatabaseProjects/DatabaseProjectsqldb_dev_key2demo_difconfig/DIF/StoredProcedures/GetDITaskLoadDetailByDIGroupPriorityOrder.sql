

CREATE   PROCEDURE [DIF].[GetDITaskLoadDetailByDIGroupPriorityOrder]
	(
	@DIGroupKey smallint
	,@DIGroupTaskPriorityOrder smallint
	)
AS

/*

SP Name:  [DIF].[GetDITaskLoadDetailByDIGroupPriorityOrder]
Purpose:  Used to get load details for a given set of tasks associated with a data integration group and its execution order
Parameters:
     @DIGroupKey - the key for a given data integration group
	 @DIGroupTaskPriorityOrder - Execution order for a given set of tasks in a DI group

Test harnass:

SELECT * FROM [DIF].[SystemDetail]
SELECT * FROM [DIF].[RepositoryDetail]
SELECT * FROM [DIF].[DatasetDetail]
SELECT * FROM [DIF].[DITaskDetail]

EXEC [DIF].[GetDITaskLoadDetailByDIGroupPriorityOrder]
	@DIGroupKey = 4
	,@DIGroupTaskPriorityOrder = 1

*/

BEGIN

DECLARE
	@DIGroupTaskKey INT;

BEGIN TRY

SELECT
	@DIGroupTaskKey = a.[DITaskKey]
FROM
	[config].[DIGroupTask] AS a
WHERE
	a.DIGroupKey = @DIGroupKey
	and a.DIGroupTaskPriorityOrder = @DIGroupTaskPriorityOrder;

IF @DIGroupTaskKey IS NULL
	THROW 50101, 'An unknown data integration task was identified by the @DIGroupTaskKey parameter.', 1;

SELECT
	a.DITaskKey
	,a.[SourceSystemFQDN]
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
	,CASE WHEN a.SourceOverrideQuery IS NOT NULL THEN STUFF(a.SourceOverrideQuery,7,CHARINDEX('FROM',a.SourceOverrideQuery)-7,' isNull(MAX('+att.AttributeName+'),0) as MaxWaterMark ')
		ELSE 'SELECT MAX('+att.AttributeName+') as MaxWaterMark FROM '+ a.[SourceDatasetPath] + ' WHERE '+att.AttributeName+' > ' + case when dt.DataType in ('tinyint','smallint','int','bigint') then isNull(a.DITaskMaxWaterMark,'0')
																			when dt.DataType in ('smalldatetime','datetime','datetime2','date') then ''''+isNull(a.DITaskMaxWaterMark,'1/1/1900')+''''
																		else ''
																		end 
	 END as SourceWaterMarkQuery
	,b.RelatedDIGroupTaskKey
	,rgt.DITaskKey as RelatedDITaskKey
	,rgt.PipelineFullName as RelatedPipelineFullName
	,COALESCE(a.SourceAuditQuery, '') [SourceAuditQuery]
FROM
	[DIF].[DITaskDetail] AS a
		INNER JOIN [config].[DIGroupTask] b
			on a.DITaskKey = b.DITaskKey
		LEFT OUTER JOIN [metadata].Attribute att
			on att.DatasetKey = a.SourceDatasetKey
			and att.AttributeIsWaterMark = 1
		LEFT OUTER JOIN [reference].DataType dt
			on att.DataTypeKey = dt.DataTypeKey
		LEFT OUTER JOIN DIF.DIGroupTaskDetail rgt
			on b.RelatedDIGroupTaskKey = rgt.DIGroupTaskKey
WHERE
	b.DIGroupKey = @DIGroupKey
	and b.DIGroupTaskPriorityOrder = @DIGroupTaskPriorityOrder
	and a.DITaskIsEnabled = 1;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

