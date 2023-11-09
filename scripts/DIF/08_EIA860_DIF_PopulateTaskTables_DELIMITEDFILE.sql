
/*
							
--------------------------------------------------------------------------------------
Set @IsReadOnlyMode = 0 to override read-only mode and perfrom inserts 				
--------------------------------------------------------------------------------------
*/


USE [sqldb_dev_key2demo_difconfig];
GO



DECLARE
	@IsReadOnlyMode BIT = 1
	,@DIGroupName VARCHAR(255) = 'EIA-ElecGen-DF to Bronze + Silver Zones'
	,@PipelineFullName VARCHAR(255) = 'PL_DIF_DelimitedFile_GroupOrder'
	,@RelatedPipelineFullName VARCHAR(255) = 'PL_DIF_DelimitedFile_RawToRefined'
	,@SourceToRawLoadType VARCHAR(50) = 'Full Only' 
	,@RefinedZoneLogicalDatabaseName VARCHAR(255) = 'eia_silver'
	,@IsRawToRefinedDataset BIT = 1
	,@RefinedSystemName VARCHAR(50) = 'stkey2demodeveastus001'
	,@RefinedRepositoryName VARCHAR(50) = 'silverzone'
	,@RefinedDatasetNameSpace VARCHAR(255) = 'eiasurvey'
	,@RefinedDatasetPath VARCHAR(255) = 'eia'
	,@RefinedDatasetClass VARCHAR(255) = 'Reference Table'
	,@RefinedStorageType VARCHAR(255) = 'Parquet File'
	,@RefinedInitialLoadType VARCHAR(255)= 'Full Only'  -------'Full then Incremental'----'Full Only' ----'Incremental'  --IMPORTANT:  Add update statement for DITasks that are not @RefinedInitialLoadType
	,@ExecutionGroup INT = 1;

DECLARE @DIGroupKey INT;
	SELECT @DIGroupKey = DIGroupKey FROM config.DIGroup WHERE DIGroupName = @DIGroupName;

DECLARE @PipelineKey INT;
	SELECT @PipelineKey = PipelineKey FROM [config].[Pipeline] WHERE PipelineFullName = @PipelineFullName;

DECLARE @RelatedPipelineKey INT;
	SELECT @RelatedPipelineKey = PipelineKey FROM [config].[Pipeline] WHERE PipelineFullName = @RelatedPipelineFullName;



DROP TABLE IF EXISTS #DatasetMapping;

WITH CTE_DF AS
(
	SELECT
		SD.*
	FROM
		[DIF].[DatasetDetail] SD
	WHERE
		1=1		
		AND SD.DatasetNameSpace = 'eia860_utility_annual'  --IMPORTANT! UPDATE THIS WHEN NEEDED!!!!!!!!!!!!!!
)

SELECT  
	SourceDatasetKey = SRC.DatasetKey,
	SourceEnvironmentType = SRC.EnvironmentType,
	SourceSystemType = SRC.SystemType,
	SourceSystemName = SRC.SystemName,
	SourceSystemFQDN = SRC.SystemFQDN,
	SourceSystemUserName = SRC.SystemUserName,
	SourceSystemSecretName = SRC.SystemSecretName,
	SourceSystemIsEnabled = SRC.SystemIsEnabled,
	SourceRepositoryType = SRC.RepositoryType,
	SourceRepositoryName = SRC.RepositoryName,
	SourceRepositoryIsEnabled = SRC.RepositoryIsEnabled,
	SourceStorageType = SRC.StorageType,
	SourceDatasetClass = SRC.DatasetClass,
	SourcePartitionType = SRC.PartitionType,
	SourceDatasetNameSpace = SRC.DatasetNameSpace,
	SourceDatasetName = SRC.DatasetName,
	SourceDatasetDescription = SRC.DatasetDescription,
	SourceDatasetPath = SRC.DatasetPath,
	SourceDatasetInternalVersionID = SRC.DatasetInternalVersionID,
	SourceDatasetExternalVersionID = SRC.DatasetExternalVersionID,
	SourceDatasetIsLatestVersion = SRC.DatasetIsLatestVersion,
	SourceDatasetIsCreated = SRC.DatasetIsCreated,
	SourceDatasetIsEnabled = SRC.DatasetIsEnabled,
	SourceLogicalDatabaseName = SRC.LogicalDatabaseName,
	
	DestinationDatasetKey = TRG.DatasetKey,
	DestinationEnvironmentType = TRG.EnvironmentType,
	DestinationSystemType = TRG.SystemType,
	DestinationSystemName = TRG.SystemName,
	DestinationSystemFQDN = TRG.SystemFQDN,
	DestinationSystemUserName = TRG.SystemUserName,
	DestinationSystemSecretName = TRG.SystemSecretName,
	DestinationSystemIsEnabled = TRG.SystemIsEnabled,
	DestinationRepositoryType = TRG.RepositoryType,
	DestinationRepositoryName = TRG.RepositoryName,
	DestinationRepositoryIsEnabled = TRG.RepositoryIsEnabled,
	DestinationStorageType = TRG.StorageType,
	DestinationDatasetClass = TRG.DatasetClass,
	DestinationPartitionType = TRG.PartitionType,
	DestinationDatasetNameSpace = @RefinedDatasetNameSpace, ------- TRG.DatasetNameSpace
	DestinationDatasetName = TRG.DatasetName,
	DestinationDatasetDescription = TRG.DatasetDescription,
	DestinationDatasetPath = @RefinedDatasetPath, -------TRG.DatasetPath,
	DestinationDatasetInternalVersionID = TRG.DatasetInternalVersionID,
	DestinationDatasetExternalVersionID = TRG.DatasetExternalVersionID,
	DestinationDatasetIsLatestVersion = TRG.DatasetIsLatestVersion,
	DestinationDatasetIsCreated = TRG.DatasetIsCreated,
	DestinationDatasetIsEnabled = TRG.DatasetIsEnabled,
	DestinationLogicalDatabaseName = TRG.LogicalDatabaseName
INTO #DatasetMapping
FROM 
	CTE_DF SRC
	LEFT JOIN CTE_DF TRG
		ON SRC.DatasetName = TRG.DatasetName
		AND TRG.StorageType = 'Parquet File'
WHERE
	1=1
	AND SRC.RepositoryName = 'landingzone'
	AND SRC.StorageType = 'Delimited Text File';

SELECT * FROM #DatasetMapping;


DECLARE @SourceDatasetKey INT;
DECLARE @SourceStorageType VARCHAR(255);

DECLARE @SourceDatasetNameSpace VARCHAR(255);
DECLARE @SourceDatasetName VARCHAR(255);
DECLARE @SourceDatasetPath VARCHAR(255);



DECLARE @DestinationDatasetKey INT;
DECLARE @DestinationStorageType VARCHAR(255);

DECLARE @DestinationDatasetPath VARCHAR(255);
DECLARE @DestinationDatasetNameSpace VARCHAR(255);
DECLARE @DestinationDatasetName VARCHAR(255);



DECLARE @ConfigureDatasetAndTaskSQL_Master VARCHAR(MAX) =
'
	DECLARE @IsRawToRefinedDataset BIT = CAST($IsRawToRefinedDataset AS BIT);

	/*Add Raw To Refined Destination Dataset $RefinedNameSpace: $RefinedDatasetName---- */
	DECLARE @DK1 INT;

	IF(@IsRawToRefinedDataset = 1)
	BEGIN

		EXEC [DIF].[AddDataset]
			@SystemName = ''$RefinedSystemName''
			,@RepositoryName = ''$RefinedRepositoryName''  
			,@DatasetClass = ''$RefinedDatasetClass''
			,@StorageType = ''$RefinedStorageType''
			,@PartitionType = ''None''
			,@DatasetNameSpace = ''$RefinedNameSpace''
			,@DatasetName = ''$RefinedDatasetName''
			,@DatasetDescription = ''$RefinedDatasetDescription''
			,@DatasetPath = ''$RefinedDatasetPath''
			,@DatasetExternalVersionID = NULL
			,@DatasetIsCreated = 1
			,@DatasetIsEnabled = 1
			,@DatasetKey = @DK1 OUTPUT;

		SELECT @DK1;

		UPDATE D SET LogicalDatabaseName = ''$RefinedZoneLogicalDatabaseName''
		FROM [metadata].[Dataset] D
		WHERE DatasetKey = @DK1;
		
		/*Add attributes for Refined Destination Dataset $RefinedNameSpace: $RefinedDatasetName */
		INSERT INTO [metadata].[Attribute]
		(
			[DataTypeKey]
			,[DatasetKey]
			,[AttributeName]
			,[AttributeSequenceNumber]
			,[AttributeMaxLength]
			,[AttributePrecision]
			,[AttributeScale]
			,[AttributeIsNullable]
			,[AttributeIsPrimaryKey]
			,[AttributeIsUnique]
			,[AttributeIsForeignKey]
			,[AttributeIsWaterMark]
			,[AttributePartitionKeyOrder]
			,[AttributeDistributionKeyOrder]
			,[AttributeIsEnabled]
		)
		SELECT
			[DataTypeKey]
			,[DatasetKey] = @DK1
			,[AttributeName]
			,[AttributeSequenceNumber]
			,[AttributeMaxLength]
			,[AttributePrecision]
			,[AttributeScale]
			,[AttributeIsNullable]
			,[AttributeIsPrimaryKey]
			,[AttributeIsUnique]
			,[AttributeIsForeignKey]
			,[AttributeIsWaterMark]
			,[AttributePartitionKeyOrder]
			,[AttributeDistributionKeyOrder]
			,[AttributeIsEnabled]
		FROM
			[metadata].[Attribute]
		WHERE
			[DatasetKey] = $DestinationDatasetKey;
		

	END
	
	
	DECLARE @DIK1 INT;

	/*Add Source To Raw DITask $SourceDatasetDetails to $DestinationDatasetDetails*/
	EXEC [DIF].[AddDITask]
		@SourceDatasetKey = $SourceDatasetKey
		,@DestinationDatasetKey = $DestinationDatasetKey
		,@LoadType = ''$SourceToRawLoadType''
		,@DITaskSourceFilterLogic = NULL
		,@DITaskWaterMarkLogic = NULL
		,@DITaskEnabled = 1
		,@SourceFilterLogicIsEnabled = 0
		,@DITask = @DIK1 OUTPUT;

	 SELECT @DIK1;

	DECLARE @DIK2 INT;

	/*Add Raw To Refined DITask $DestinationDatasetDetails to $RefinedZoneLogicalDatabaseName*/


	IF(@IsRawToRefinedDataset = 1)
	BEGIN

		EXEC [DIF].[AddDITask]
			@SourceDatasetKey = $DestinationDatasetKey
			,@DestinationDatasetKey = @DK1
			,@LoadType = ''$RefinedInitialLoadType''
			,@DITaskSourceFilterLogic = NULL
			,@DITaskWaterMarkLogic = NULL
			,@DITaskEnabled = 1
			,@SourceFilterLogicIsEnabled = 0
			,@DITask = @DIK2 OUTPUT;

		SELECT @DIK2;

	END

	/*AddDIGroupTask Source to Raw: $SourceDatasetDetails to $DestinationDatasetDetails */
	EXEC [DIF].[AddDIGroupTask]
		@DIGroupKey = $DIGroupKey
		,@DITaskKey = @DIK1
		,@DIGroupTaskPriorityOrder = $ExecutionGroup
		,@PipelineKey = $PipelineKey
		,@RelatedDIGroupTaskKey = NULL;


	IF(@IsRawToRefinedDataset = 1)
	BEGIN

		/*AddDIGroupTask Raw to Refined: $DestinationDatasetDetails to $RefinedZoneLogicalDatabaseName */	
		EXEC [DIF].[AddDIGroupTask]
			@DIGroupKey = $DIGroupKey
			,@DITaskKey = @DIK2
			,@DIGroupTaskPriorityOrder = 0
			,@PipelineKey = $RelatedPipelineKey
			,@RelatedDIGroupTaskKey = NULL;

	 END


	 /*Set RelatedDIGroupTaskKey for $DestinationDatasetDetails to $RefinedZoneLogicalDatabaseName */

	DECLARE @DIGTK1 INT = (SELECT MAX(DIGroupTaskKey) FROM [config].[DIGroupTask] );


	IF(@IsRawToRefinedDataset = 1)
	BEGIN

		UPDATE GT SET GT.RelatedDIGroupTaskKey = @DIGTK1
		FROM [config].[DIGroupTask] GT
		WHERE DIGroupTaskKey = @DIGTK1 - 1;

	END


'

DECLARE @ConfigureDatasetAndTaskSQL_Replaced VARCHAR(MAX) = @ConfigureDatasetAndTaskSQL_Master;



DECLARE c_DatasetMapping CURSOR FOR

SELECT  	
	SourceDatasetKey,
	SourceStorageType,
	SourceDatasetNameSpace,
	SourceDatasetName,
	SourceDatasetPath,

	DestinationDatasetKey,
	DestinationStorageType,
	DestinationDatasetNameSpace,
	DestinationDatasetName,
	DestinationDatasetPath
FROM 
	#DatasetMapping;


OPEN c_DatasetMapping
FETCH NEXT FROM c_DatasetMapping INTO @SourceDatasetKey, @SourceStorageType, @SourceDatasetNameSpace,  @SourceDatasetName, @SourceDatasetPath, @DestinationDatasetKey, @DestinationStorageType, @DestinationDatasetNameSpace, @DestinationDatasetName, @DestinationDatasetPath;

WHILE @@FETCH_STATUS = 0
BEGIN 
	
	/*
	SELECT  	
		SourceDatasetKey = @SourceDatasetKey,
		DestinationDatasetKey = @DestinationDatasetKey
	*/
 
	
	

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$IsRawToRefinedDataset', @IsRawToRefinedDataset);
	
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedNameSpace', @DestinationDatasetNameSpace);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedDatasetName', @DestinationDatasetName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedDatasetDescription', @DestinationDatasetName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedDatasetPath', @DestinationDatasetPath);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedZoneLogicalDatabaseName', @RefinedZoneLogicalDatabaseName);
	
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedSystemName', @RefinedSystemName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedRepositoryName', @RefinedRepositoryName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedDatasetClass', @RefinedDatasetClass);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedStorageType', @RefinedStorageType);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedInitialLoadType', @RefinedInitialLoadType);

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$SourceDatasetDetails', @SourceStorageType + '-' + @SourceDatasetName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$DestinationDatasetDetails', @DestinationStorageType + '-' + @DestinationDatasetName);

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$SourceDatasetKey', @SourceDatasetKey);

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$SourceDatasetKey', @SourceDatasetKey);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$DestinationDatasetKey', @DestinationDatasetKey);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$SourceToRawLoadType', @SourceToRawLoadType);

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedInitialLoadType', @RefinedInitialLoadType);

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RefinedZoneLogicalDatabaseName', @RefinedZoneLogicalDatabaseName);

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$DIGroupKey', @DIGroupKey);

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$PipelineKey', @PipelineKey);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$RelatedPipelineKey', @RelatedPipelineKey);
	

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$ExecutionGroup', @ExecutionGroup);
	
	
	
	

	SELECT ConfigureDatasetAndTaskSQL_Replaced = @ConfigureDatasetAndTaskSQL_Replaced;

	IF(@IsReadOnlyMode = 0)
		BEGIN
			EXEC(@ConfigureDatasetAndTaskSQL_Replaced);
		END

	SET  @ConfigureDatasetAndTaskSQL_Replaced = @ConfigureDatasetAndTaskSQL_Master;
	
	FETCH NEXT FROM c_DatasetMapping INTO @SourceDatasetKey, @SourceStorageType, @SourceDatasetNameSpace,  @SourceDatasetName, @SourceDatasetPath, @DestinationDatasetKey, @DestinationStorageType, @DestinationDatasetNameSpace, @DestinationDatasetName, @DestinationDatasetPath;

END

CLOSE c_DatasetMapping
DEALLOCATE c_DatasetMapping

--END





