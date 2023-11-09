






-- =============================================
-- Author:		Key2
-- Create date: 2023-04-20
-- Description:		Used in "PL_DIF_DimUnitLocation_Master" pipeline to fetch details for merging DimUnitLocation

/*


SELECT * FROM [DIF].[udf_GetDITaskDimUnitLocationTargetDetails]('EIM-Location Manager-DimUnitLocation', 'EIM-DimUnitLocation Refined to Lakehouse', '^')

*/


-- =============================================
CREATE FUNCTION [DIF].[udf_GetDITaskDimUnitLocationTargetDetails] 
(	
	@ProjectName VARCHAR(50),
	@DIGroupName VARCHAR(50),
	@RevistTableDelimiter VARCHAR(20)

)
RETURNS TABLE 
AS
RETURN 
(
	
	/*
	DECLARE @ProjectName VARCHAR(50) = 'EIM-Location Manager-DimUnitLocation';
	DECLARE @DIGroupName VARCHAR(50) = 'EIM-DimUnitLocation Refined to Lakehouse';
	DECLARE @RevistTableDelimiter VARCHAR(20) = '^';
	*/

	SELECT
		AnchorProjectName = agt.ProjectName,
		AnchorDIGroupName = agt.DIGroupName,
		td.DITaskKey,
		gt.DIGroupTaskPriorityOrder,
		gt.DIGroupTaskKey,
		gt.RelatedDIGroupTaskKey,
		td.SourceDatasetKey,
		td.SourceDatasetName,
		td.DestinationDatasetKey,
		LakeHouseLoadType = td.LoadType,
		LakehouseRepositoryName = td.DestinationRepositoryName,
		LakehouseMountPoint = '/mnt/' + td.DestinationRepositoryName,
		LakehouseTargetSchema = td.DestinationDatasetNameSpace,
		/*LakehouseTargetTable = td.DestinationDatasetName,*/
		LakehouseTargetTableUnique = td.DestinationDatasetName,
		LakehouseTargetTable = SUBSTRING(td.DestinationDatasetName, 1, CHARINDEX(@RevistTableDelimiter, td.DestinationDatasetName + @RevistTableDelimiter) - 1 ),
		/*LakehouseFolder = REPLACE(td.DestinationDatasetPath, '\', '/') + '/',*/
		LakehouseFolder =  REPLACE(SUBSTRING(td.DestinationDatasetPath, 1, CHARINDEX(@RevistTableDelimiter, td.DestinationDatasetPath + @RevistTableDelimiter) - 1 ), '\', '/') + '/',
		DITaskWaterMarkLogic = ISNULL(td.DITaskWaterMarkLogic, ''),
		DITaskMaxWaterMark = ISNULL(td.DITaskMaxWaterMark, ''),
		td.NotebookPath,
		RelatedProjectName = rgt.ProjectName,
		RelatedDIGroupName = rgt.DIGroupName,
		TargetAzureSQLHost = ISNULL(tdr.DestinationSystemFQDN, ''),  
		TargetAzureSQLDB = ISNULL(rgt.DestinationRepositoryName, ''),
		TargetAzureSQLSchema = ISNULL(rgt.DestinationDatasetNameSpace, ''),
		TargetAzureSQLTable = ISNULL(rgt.DestinationDatasetName, ''),	
		TargetAzureSQLUserID = ISNULL(tdr.DestinationSystemUserName, ''),
		TargetAzureSQLSecretName = ISNULL(tdr.DestinationSystemSecretName, ''),
		DuplicateCheckInLakehouseTarget = 'Y',
		
		TargetAzureSQLDWSchemaName = ISNULL(SUBSTRING(rgt.DestinationDatasetName, 1, CHARINDEX('_', rgt.DestinationDatasetName + '_') - 1 ), ''),
		TargetAzureSQLDWTableName = ISNULL(SUBSTRING(rgt.DestinationDatasetName, CHARINDEX('_', rgt.DestinationDatasetName + '_') + 1, LEN(rgt.DestinationDatasetName) ), ''),
		RelatedDITaskKey = tdr.DITaskKey,
		RelatedNotebookPath = tdr.NotebookPath
	FROM 
		DIF.DITaskDetail td
		INNER JOIN [config].[DIGroupTask] gt
			ON td.DITaskKey = gt.DITaskKey
		 INNER JOIN DIF.DIGroupTaskDetail agt
			ON gt.DIGroupTaskKey = agt.DIGroupTaskKey
		LEFT JOIN DIF.DIGroupTaskDetail rgt
			ON gt.RelatedDIGroupTaskKey = rgt.DIGroupTaskKey
		LEFT JOIN DIF.DITaskDetail tdr
			ON tdr.DITaskKey = rgt.DITaskKey
	WHERE 
		1=1			
		AND td.SourceDatasetName = 'Multiple Sources'
		AND agt.ProjectName = @ProjectName
		AND agt.DIGroupName = @DIGroupName
)

GO

