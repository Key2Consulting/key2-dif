




-- =============================================
-- Author:		Mark Swiderski
-- Create date: 2022-03-25
-- Description:	Used to fetch delimited file to parquet task data. 
--				Assembles destination file folder and file name prefix and joins to source/destination attributes pulled from DITaskDetail
--				Created as TVF (instead of view) because logic may need to support params that dictate how file names and paths are constructed below.  These may vary by project/pipeline etc.

/*


SELECT * FROM [DIF].[udf_GetDITaskDelimitedFileList]('Delimited Text File')

*/


-- =============================================
CREATE FUNCTION [DIF].[udf_GetDITaskDelimitedFileList] 
(	
	@SourceDatasetStorageType VARCHAR(50)
	/*@DestinationFileNamePattern VARCHAR(100)  --possible future use?  */
)
RETURNS TABLE 
AS
RETURN 
(
	
	SELECT
		PD.ProjectKey,
		PD.ProjectName,
		PD.ProjectType,
		DIG.DIGroupName,
		DIG.DIGroupKey,
		DIG.DIGroupIsEnabled,
		GT.DIGroupTaskKey,
		GT.DIGroupTaskPriorityOrder,
		GT.PipelineKey,
		TD.DITaskKey,
		TD.DITaskIsEnabled,
		SourceDatasetStorageType = DSource.StorageType,
		TD.SourceDatasetKey,
		TD.[SourceSystemFQDN],
		TD.[SourceSystemUserName],
		TD.[SourceSystemSecretName],
		TD.[SourceRepositoryName],
		TD.[SourceDatasetNameSpace],
		TD.[SourceDatasetName],
		TD.[SourceDatasetPath],		
		SourceDelimitedFileKey = DF.DelimitedFileKey,
		SourceDelimitedFileCompressionType = DF.DelimitedFileCompressionType,
		SourceDelimitedFileCompressionLevel = DF.DelimitedFileCompressionLevel,
		SourceDelimitedFileColumnDelimiter = DF.DelimitedFileColumnDelimiter,
		SourceDelimitedFileRowDelimiter = DF.DelimitedFileRowDelimiter,
		SourceDelimitedFileEncoding = DF.DelimitedFileEncoding,
		SourceDelimitedFileEscapeCharacter = DF.DelimitedFileEscapeCharacter,
		SourceDelimitedFileQuoteCharacter = DF.DelimitedFileQuoteCharacter,
		SourceDelimitedFileFirstRowAsHeader = DF.DelimitedFileFirstRowAsHeader,
		SourceDelimitedFileNULLValue = DF.DelimitedFileNULLValue,
		SourceDelimitedFileNamePattern = DF.DelimitedFileNamePattern,
		SourceDelimitedFileIsHeaderRowOverride = ISNULL(DF.DelimitedFileIsHeaderRowOverride, 0),
		TD.DestinationDatasetKey,
		TD.[DestinationSystemFQDN],
		TD.[DestinationSystemUserName],
		TD.[DestinationSystemSecretName],
		TD.[DestinationRepositoryName],
		TD.[DestinationDatasetNameSpace],
		TD.[DestinationDatasetName],
		TD.[DestinationDatasetPath],			
		--leave commented IngestionFileName logic for now, along with supporting joins below
		/*IngestionFileName = REPLACE(REPLACE(  ----logic taken verbatim from [DIF].[GetDITaskQueryList] / IngestionFileName, except wrapped in REPLACE to remove / and \ in file name
			CASE 
				WHEN TD.LoadType like 'Full%' THEN 
					CASE 
						WHEN PB1.PartitionBoundaryMinValue = 'NULL' THEN 'NULL_'
						WHEN PT1.PartitionType = 'Year' THEN PB1.PartitionBoundaryMinValue+'_'+PB1.PartitionBoundaryMaxValue+'_'
						WHEN PT1.PartitionType = 'Quarter' THEN convert(varchar(50),cast(PB1.PartitionBoundaryMinValue as datetime2(0)),112)+'_'+convert(varchar(50),cast(PB1.PartitionBoundaryMaxValue as datetime2(0)),112)+'_'
						WHEN A1.AttributePartitionKeyOrder > 0 THEN PB1.PartitionBoundaryMinValue+'_'
						ELSE convert(varchar(255),cast(getdate() as datetime2(0)),112)+'_'+replace(convert(varchar(255),cast(getdate() as datetime2(0)),108),':','.')+'_'
					END
				WHEN TD.LoadType = 'Incremental' THEN
					CASE 
						WHEN DT2.DataType in ('tinyint','smallint','int','bigint') then @MaxWaterMark+'_'
						WHEN DT2.DataType in ('smalldatetime','datetime','datetime2','date') then convert(varchar(255),cast(@MaxWaterMark as datetime2(0)),112)+'_'+replace(convert(varchar(255),cast(@MaxWaterMark as datetime2(0)),108),':','.')+'_'
						ELSE ''
					END
				ELSE ''
			END 
			+DS.DatasetPath + '.parquet','\','_'),'/','_') ,*/

		DestinationFileNamePrefix = 
			CONVERT(VARCHAR(255),CAST(GETDATE() AS DATETIME2(0)),112)+'_'+ REPLACE(CONVERT(VARCHAR(255),CAST(GETDATE() AS DATETIME2(0)),108),':','.')
			+'_'
			+TD.DestinationDatasetNameSpace
			+'_',
		
		--leave commented LoadFolder logic for now, along with supporting joins below
		/*LoadFolder = -- logic taken verbatim from [DIF].[GetDITaskQueryList]
			TD.[DestinationDatasetPath]+'\'+ TD.[SourceDatasetPath] +'\'
			+CASE TD.LoadType 
				WHEN 'Incremental' THEN 'incremental'
				ELSE 'full'
			END
			+'\'+CAST(DATEPART(YYYY,GETUTCDATE()) AS VARCHAR(4))
			+'\'+RIGHT('00'+CAST(DATEPART(MM,GETUTCDATE()) AS VARCHAR(2)),2)
			+'\'+RIGHT('00'+CAST(DATEPART(DD,GETUTCDATE()) AS VARCHAR(2)),2),*/

		DestinationLoadFolder = 
			TD.[DestinationDatasetPath] +'/'
			--+ TD.[SourceDatasetPath] +'/'
			+ 'full'  --force to full as delimited file loads don't support incremental loads	
			+'/'+CAST(DATEPART(YYYY,GETUTCDATE()) AS VARCHAR(4))
			+'/'+RIGHT('00'+CAST(DATEPART(MM,GETUTCDATE()) AS VARCHAR(2)),2)
			+'/'+RIGHT('00'+CAST(DATEPART(DD,GETUTCDATE()) AS VARCHAR(2)),2)
			+'/'+RIGHT('00'+CAST(DATEPART(HH,GETUTCDATE()) AS VARCHAR(2)),2) + RIGHT('00'+CAST(DATEPART(MI,GETUTCDATE()) AS VARCHAR(2)),2) + RIGHT('00'+CAST(DATEPART(SS,GETUTCDATE()) AS VARCHAR(2)),2)
			,
		TD.[LoadType],
		GT.RelatedDIGroupTaskKey,	
		RGT.RelatedDITaskKey,	
		RGT.RelatedPipelineFullName,
		TD.SourceAuditQuery
	FROM
		[DIF].[DITaskDetail] TD
		INNER JOIN [config].[DIGroupTask] GT
			ON GT.DITaskKey = TD.DITaskKey
		INNER JOIN [config].[DIGroup] DIG
			ON DIG.DIGroupKey = GT.DIGroupKey

		INNER JOIN [DIF].DatasetDetail DSource 
			ON TD.SourceDatasetKey = DSource.DatasetKey

		INNER JOIN [DIF].[ProjectDetail] PD
			ON PD.ProjectKey = DIG.ProjectKey
		LEFT JOIN DIF.DIGroupTaskDetail RGT
			on GT.RelatedDIGroupTaskKey = RGT.DIGroupTaskKey
		LEFT JOIN [metadata].[DelimitedFile] DF
			ON DF.DatasetKey = TD.SourceDatasetKey
		--joins below here used to support IngestionFileName and LoadFolder attributes from existint [DIF].[GetDITaskQueryList].  Leave commented for now.
		/*INNER JOIN [metadata].Dataset AS DS 
			ON TD.SourceDatasetKey = DS.DatasetKey
		LEFT JOIN [metadata].Attribute A1 
			ON DS.DatasetKey = A1.DatasetKey 
			AND A1.AttributeIsEnabled = 1
			AND A1.AttributePartitionKeyOrder > 0
		LEFT JOIN [reference].[PartitionType] PT1 
			ON DS.PartitionTypeKey = PT1.PartitionTypeKey
			and TD.LoadType like 'Full%'
		LEFT JOIN [config].[PartitionBoundary] PB1
			ON PB1.PartitionTypeKey = PT1.PartitionTypeKey
		LEFT JOIN [metadata].Attribute A2--Watermark 
			ON DS.DatasetKey = A2.DatasetKey 
			AND A2.AttributeIsEnabled = 1
			AND A2.AttributeIsWaterMark = 1
		LEFT JOIN [reference].DataType DT2 
			ON A2.DataTypeKey=DT2.DataTypeKey */			
	WHERE
		TD.DITaskIsEnabled = 1
		AND DSource.StorageType = @SourceDatasetStorageType
)

GO

