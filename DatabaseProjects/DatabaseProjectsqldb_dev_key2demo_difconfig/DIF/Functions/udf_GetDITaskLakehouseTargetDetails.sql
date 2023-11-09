









-- =============================================
-- Author:		Mark Swiderski
-- Create date: 2022-04-21
-- Description:		Used in "DIF_Lakehouse_Ingestion" pipeline to fetch details for loading lakehouse dims/facts.  

/*


SELECT * FROM [DIF].[udf_GetDITaskLakehouseTargetDetails] (12)

*/


-- =============================================
CREATE FUNCTION [DIF].[udf_GetDITaskLakehouseTargetDetails] 
(	
	@DITaskKey SMALLINT


)
RETURNS TABLE 
AS
RETURN 
(
	
	SELECT
		td.DITaskKey,
		gt.RelatedDIGroupTaskKey,
		td.SourceDatasetKey,
		td.SourceDatasetName,
		td.DestinationDatasetKey,
		LakeHouseLoadType = td.LoadType,
		LakehouseRepositoryName = td.DestinationRepositoryName,
		LakehouseMountPoint = '/mnt/' + td.DestinationRepositoryName,
		LakehouseTargetSchema = td.DestinationDatasetNameSpace,
		LakehouseTargetTable = td.DestinationDatasetName,
		LakehouseFolder = REPLACE(td.DestinationDatasetPath, '\', '/') + '/',
		DITaskWaterMarkLogic = ISNULL(td.DITaskWaterMarkLogic, ''),
		DITaskMaxWaterMark = ISNULL(td.DITaskMaxWaterMark, ''),
		td.NotebookPath,
		TargetAzureSQLHost = tdr.DestinationSystemFQDN,  --DestinationSystemName
		TargetAzureSQLDB = rgt.DestinationRepositoryName,
		TargetAzureSQLSchema = rgt.DestinationDatasetNameSpace,
		TargetAzureSQLTable = rgt.DestinationDatasetName,	
		TargetAzureSQLUserID = tdr.DestinationSystemUserName,
		TargetAzureSQLSecretName = tdr.DestinationSystemSecretName,
		DuplicateCheckInLakehouseTarget = 'Y'  --TO DO: store this value in db for each target
	FROM 
		DIF.DITaskDetail td
		INNER JOIN [config].[DIGroupTask] gt
			ON td.DITaskKey = gt.DITaskKey
		LEFT JOIN DIF.DIGroupTaskDetail rgt
			ON gt.RelatedDIGroupTaskKey = rgt.DIGroupTaskKey
		LEFT JOIN DIF.DITaskDetail tdr
			ON tdr.DITaskKey = rgt.DITaskKey
	WHERE 
		1=1			
		AND td.DITaskKey = @DITaskKey 
		AND td.SourceDatasetName = 'Multiple Sources'
)

GO

