






-- =============================================
-- Author:		Mark Swiderski
-- Create date: 2022-04-07
-- Description:	Used in "DelimitedFile_RawToRefined" pipeline to fetch details for raw zone files ultimately sourced from delimited files.  

/*


SELECT * FROM [DIF].[[udf_GetRawDelimitedFileDetails_BACK20230829]](6)

*/


-- =============================================
CREATE FUNCTION [DIF].[udf_GetRawDelimitedFileDetails_BACK20230829] 
(	
	@DITaskKey SMALLINT


)
RETURNS TABLE 
AS
RETURN 
(
	
	WITH CTE_LatestPipelineResults AS
	(
		SELECT
			L.*
		FROM
		(
			SELECT 
				pa.DITaskKey,
				prn.PipelineResultName,
				prs.PipelineResultValue,
				RowNum = ROW_NUMBER() OVER (PARTITION BY pa.DITaskKey, prn.PipelineResultName ORDER BY pa.PipelineActivityStartDateTime DESC)  
			FROM 
				logging.PipelineActivity pa
				INNER JOIN logging.PipelineRun pr
					on pa.PipelineRunKey = pr.PipelineRunKey
				INNER JOIN config.Pipeline p
					on pr.PipelineKey = p.PipelineKey
				INNER JOIN logging.PipelineResult prs
					on pa.PipelineActivityKey = prs.PipelineActivityKey
					and pr.PipelineRunKey = prs.PipelineRunKey
				INNER JOIN reference.PipelineResultName prn
					on prs.PipelineResultNameKey = prn.PipelineResultNameKey
			WHERE 
				pa.DITaskKey = @DITaskKey
				------AND prs.PipelineResultValue like '%full%'  --for raw zone files ultimately sourced from delimited files, the load type should always be full
		) L
		WHERE
			L.RowNum = 1
	),	
	CTE_DITaskInfo AS
	(
		SELECT
			td.DITaskKey,
			----td.SourceDatasetKey,
			----td.DestinationDatasetKey,
			RelatedDITaskKey = rgt.DITaskKey,
			rawMountPoint = '/mnt/' + td.DestinationRepositoryName, 
			rawContainer = td.DestinationRepositoryName, 
			rawFolder = REPLACE(psp.PipelineResultValue,'\', '/') + '/',
			rawFileName = REPLACE(psfn.PipelineResultValue,'\', '/') + '/',
			SourceServerName = DestinationSystemFQDN,   
			SourceDatabaseName = REPLACE(td.DestinationRepositoryName, ' ', '_'),  --delimited file sources do not have this attribute.  Retained from SQLServer raw-to-refined logic as it will be used for delta table naming downstream.
			tableSchema = REPLACE(td.DestinationDatasetNameSpace, ' ', '_'), --delimited file sources do not have this attribute.  Retained from SQLServer raw-to-refined logic as it will be used for delta table naming downstream.
			tableName = REPLACE(td.DestinationDatasetName, ' ', '_'),  --delimited file sources do not have this attribute.  Retained from SQLServer raw-to-refined logic as it will be used for delta table naming downstream.
			MetaDataSecretName = DestinationSystemSecretName,
			DataLakeFormat = DestinationStorageType,
			RowCountAuditTolerancePct = '0',
			DuplicateCheckInRefinedZone = 'Y'
			--databricksDatabase = DestinationLogicalDatabaseName
		FROM 
			DIF.DITaskDetail td
			INNER JOIN [config].[DIGroupTask] gt
					on td.DITaskKey = gt.DITaskKey
			LEFT JOIN DIF.DIGroupTaskDetail rgt
					on gt.RelatedDIGroupTaskKey = rgt.DIGroupTaskKey			
			LEFT JOIN CTE_LatestPipelineResults psp
				ON psp.DITaskKey = td.DITaskKey
				AND psp.PipelineResultName = 'SinkPath_COMBINED'
				AND psp.PipelineResultValue like '%full%'
			LEFT JOIN CTE_LatestPipelineResults psfn
				ON psfn.DITaskKey = td.DITaskKey
				AND psfn.PipelineResultName = 'SinkFileName_COMBINED'                          
		WHERE 
			1=1			
			AND td.DITaskKey = @DITaskKey 
	),
	--unlike SQLServer raw-to-refined, we grab Attribute PK and partition data from the RELATED task's DESTINATION attributes
	--logic also supports isolating first AttributePartitionKeyOrder and building CDS of PK columns 
	CTE_RelatedDITaskInfo AS  
	(		
		SELECT
			L2.DITaskKey,
			L2.databricksDatabase,
			L2.UniqueIDColumnList,
			tablePartitionColumn = COALESCE(L2.AttributeNamePRT, 'NONE'),
			tablePartitionedByDate = CASE WHEN L2.AttributeNamePRT like '%date%' THEN 'Y' ELSE 'N' END
		FROM
		(
			SELECT
				L.DITaskKey,
				databricksDatabase = L.DestinationLogicalDatabaseName,
				L.UniqueIDColumnList,
				PartionKeySeq = ROW_NUMBER() OVER (PARTITION BY L.DITaskKey ORDER BY aprt.AttributePartitionKeyOrder),
				aprt.AttributePartitionKeyOrder,
				AttributeNamePRT = aprt.AttributeName			
			FROM
			(
				SELECT
					td.DITaskKey,
					td.DestinationDatasetKey,
					td.DestinationLogicalDatabaseName,
					UniqueIDColumnList = STRING_AGG(apk.AttributeName, ',')
				FROM
					DIF.DITaskDetail td
					LEFT JOIN metadata.Attribute apk
						ON td.DestinationDatasetKey = apk.DatasetKey
						AND apk.AttributeIsPrimaryKey = 1					
				WHERE
					td.DITaskKey = (SELECT RelatedDITaskKey FROM CTE_DITaskInfo)
				GROUP BY
					td.DITaskKey,
					td.DestinationLogicalDatabaseName,
					td.DestinationDatasetKey
			) L
			LEFT JOIN metadata.Attribute aprt
				ON L.DestinationDatasetKey = aprt.DatasetKey
				AND aprt.AttributePartitionKeyOrder > 0
		) L2
		WHERE
			L2.PartionKeySeq = 1		
	)

	SELECT 
		dit.DITaskKey,
		----dit.SourceDatasetKey,
		----dit.DestinationDatasetKey,
		dit.RelatedDITaskKey,
		dit.rawMountPoint,
		dit.rawContainer,
		dit.rawFolder,
		dit.rawFileName,
		dit.SourceServerName,
		dit.SourceDatabaseName,
		dit.tableSchema,
		dit.tableName,
		rdit.tablePartitionColumn,
		rdit.tablePartitionedByDate,
		rdit.UniqueIDColumnList,
		dit.MetaDataSecretName,
		dit.DataLakeFormat,
		dit.RowCountAuditTolerancePct,
		dit.DuplicateCheckInRefinedZone,
		rdit.databricksDatabase
	FROM 
		CTE_DITaskInfo dit
		LEFT JOIN CTE_RelatedDITaskInfo rdit
			ON rdit.DITaskKey = dit.RelatedDITaskKey
)

GO

