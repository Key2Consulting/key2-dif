/*
							
--------------------------------------------------------------------------------------
Set @IsReadOnlyMode = 0 to override read-only mode and perfrom inserts 	

--Set @ExecutionGroup as needed.  Comment/uncomment @InputString variable as needed for each execution group			
--------------------------------------------------------------------------------------
*/


/*
--Dim Load - Execution Group = 4 
DECLARE @InputString VARCHAR(MAX) = 
'
dim_plant|/Users/mark.swiderski@key2consulting.com/EIA_DIF/NB_Load_EIAElectricityGeneration_Dim_Plant,
dim_utility|/Users/mark.swiderski@key2consulting.com/EIA_DIF/NB_Load_EIAElectricityGeneration_Dim_Utility,
dim_fuel_type|/Users/mark.swiderski@key2consulting.com/EIA_DIF/NB_Load_EIAElectricityGeneration_Dim_Fuel_Type,
dim_prime_mover|/Users/mark.swiderski@key2consulting.com/EIA_DIF/NB_Load_EIAElectricityGeneration_Dim_Prime_Mover
';
*/


--Fact Load - Execution Group = 5 
DECLARE @InputString VARCHAR(MAX) = 
'
fact_generation|/Users/mark.swiderski@key2consulting.com/EIA_DIF/NB_Load_EIAElectricityGeneration_Fact_Generation
';


-------[Input Parameters]
DECLARE @IsReadOnlyMode BIT = 1;
DECLARE @MultipleSourcesDatasetName VARCHAR(255) = 'Multiple Sources'
DECLARE @ExecutionGroup INT = 5;
DECLARE @IsDeltaTableReplicatedToAzureSQL BIT = 0;

DECLARE @LakehouseSystemName VARCHAR(255) = 'stkey2demodeveastus001';
DECLARE @LakehouseRepositoryName VARCHAR(255) = 'goldzone';
DECLARE @LakehouseNameSpace VARCHAR(255) = 'eia_gold';
DECLARE @LakehouseTopLevelFolder VARCHAR(255) = 'eia';
DECLARE @LakehouseDatasetClass VARCHAR(255) = 'Reference Table';
DECLARE @LakehouseStorageType VARCHAR(255) = 'Databricks Delta Table';

DECLARE @ReplicatedDBSystemName VARCHAR(255) = '######-N/A-#####';
DECLARE @ReplicatedDBRepositoryName VARCHAR(255) = '######-N/A-#####';
DECLARE @ReplicatedDBNameSpace VARCHAR(255) = '######-N/A-#####';
DECLARE @ReplicatedDBDatasetClass VARCHAR(255) = '######-N/A-#####';
DECLARE @ReplicatedDBStorageType VARCHAR(255) = '######-N/A-#####';

DECLARE @RefinedToLakehouseDIGroupName VARCHAR(255) = 'EIA-ElecGen-Gold Zone Merge';
DECLARE @LakehouseToReplicatedDIGroupName VARCHAR(255) = '######-N/A-#####';
DECLARE @PipelineFullName VARCHAR(255) = 'PL_DIF_Lakehouse_Ingestion';


IF OBJECT_ID('tempdb..#MappingDetail') IS NOT NULL
    DROP TABLE #MappingDetail;

DECLARE @MultipleSourcesDatasetKey SMALLINT = (SELECT DatasetKey FROM [metadata].[Dataset] WHERE DatasetName = @MultipleSourcesDatasetName);

WITH CTE_InputDetail AS
(
	SELECT 
		--DT.[value],
		DeltaTable = LTRIM(RTRIM(SUBSTRING(DT.[value], 1, CHARINDEX('|', DT.[value]) - 1))),
		NotebookPath = LTRIM(RTRIM(SUBSTRING(DT.[value], CHARINDEX('|', DT.[value]) + 1, LEN(DT.[value]))))
	FROM
		STRING_SPLIT(REPLACE(REPLACE(@InputString, CHAR(10), ''),CHAR(13), '') , ',') DT
)

SELECT
	ID.DeltaTable,
	ID.NotebookPath,
	LakehouseSystemName = @LakehouseSystemName,
	LakehouseRepositoryName = @LakehouseRepositoryName,
	LakehouseDatasetClass = @LakehouseDatasetClass,
	LakehouseStorageType = @LakehouseStorageType,
	LakehouseNameSpace = @LakehouseNameSpace,
	LakehouseTopLevelFolder = @LakehouseTopLevelFolder,
	LakehouseDatasetName = LOWER(ID.DeltaTable),
	LakehouseDatasetPath = @LakehouseTopLevelFolder + '/' + LOWER(ID.DeltaTable),
	RefinedToLakehouseDIGroupKey = (SELECT DIGroupKey FROM [config].[DIGroup] WHERE DIGroupName = @RefinedToLakehouseDIGroupName),
	ReplicatedDBSystemName = @ReplicatedDBSystemName,
	ReplicatedDBRepositoryName = @ReplicatedDBRepositoryName,
	ReplicatedDBDatasetClass = @ReplicatedDBDatasetClass,
	ReplicatedDBStorageType = @ReplicatedDBStorageType,
	ReplicatedDBNameSpace = @ReplicatedDBNameSpace,
	ReplicatedDatasetName = ID.DeltaTable,
	ReplicatedDatasetPath = @ReplicatedDBNameSpace + '.' + ID.DeltaTable,
	LakehouseToReplicatedDIGroupKey = -1, --(SELECT DIGroupKey FROM [config].[DIGroup] WHERE DIGroupName = @LakehouseToReplicatedDIGroupName),
	PipelineKey = (SELECT PipelineKey FROM [config].[Pipeline] WHERE PipelineFullName = @PipelineFullName),
	IsDeltaTableReplicatedToAzureSQL = @IsDeltaTableReplicatedToAzureSQL
INTO #MappingDetail
FROM
	CTE_InputDetail ID;

SELECT * FROM #MappingDetail;


--variable declarations for cursor

DECLARE @CVDeltaTable VARCHAR(255);
DECLARE @CVNotebookPath VARCHAR(255);
DECLARE @CVLakehouseSystemName VARCHAR(255);
DECLARE @CVLakehouseRepositoryName VARCHAR(255);
DECLARE @CVLakehouseDatasetClass VARCHAR(255);
DECLARE @CVLakehouseStorageType VARCHAR(255);
DECLARE @CVLakehouseNameSpace VARCHAR(255);
DECLARE @CVLakehouseTopLevelFolder VARCHAR(255);
DECLARE @CVLakehouseDatasetName VARCHAR(255);
DECLARE @CVLakehouseDatasetPath VARCHAR(255);
DECLARE @CVRefinedToLakehouseDIGroupKey SMALLINT;
DECLARE @CVReplicatedDBSystemName VARCHAR(255);
DECLARE @CVReplicatedDBRepositoryName VARCHAR(255);
DECLARE @CVReplicatedDBDatasetClass VARCHAR(255);
DECLARE @CVReplicatedDBStorageType VARCHAR(255);
DECLARE @CVReplicatedDBNameSpace VARCHAR(255);
DECLARE @CVReplicatedDatasetName VARCHAR(255);
DECLARE @CVReplicatedDatasetPath VARCHAR(255);
DECLARE @CVLakehouseToReplicatedDIGroupKey SMALLINT;
DECLARE @CVPipelineKey SMALLINT;
DECLARE @CVIsDeltaTableReplicatedToAzureSQL BIT;

DECLARE @ConfigureDatasetAndTaskSQL_Master VARCHAR(MAX) =
'
DECLARE @IsDeltaTableReplicatedToAzureSQL BIT = CAST($CVIsDeltaTableReplicatedToAzureSQL AS BIT);

/*Add Dataset $CVLakehouseDatasetName---- (in refined zone LAKEHOUSE)*/
DECLARE @DK1 SMALLINT;

EXEC [DIF].[AddDataset]
	@SystemName = ''$CVLakehouseSystemName''
	,@RepositoryName = ''$CVLakehouseRepositoryName''  
	,@DatasetClass = ''$CVLakehouseDatasetClass''
	,@StorageType = ''$CVLakehouseStorageType''
	,@PartitionType = ''None''
	,@DatasetNameSpace = ''$CVLakehouseNameSpace''
	,@DatasetName = ''$CVLakehouseDatasetName''
	,@DatasetDescription = ''''
	,@DatasetPath = ''$CVLakehouseDatasetPath''
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK1 OUTPUT;

SELECT @DK1;

UPDATE D SET LogicalDatabaseName = ''$CVLakehouseNameSpace''
FROM [metadata].[Dataset] D
WHERE DatasetKey = @DK1;



/*Add Dataset $CVReplicatedDatasetPath---- (in post lakehouse Azure SQL table )*/
DECLARE @DK2 SMALLINT;

IF(@IsDeltaTableReplicatedToAzureSQL = 1)
BEGIN

	EXEC [DIF].[AddDataset]
		@SystemName = ''$CVReplicatedDBSystemName''
		,@RepositoryName = ''$CVReplicatedDBRepositoryName''  
		,@DatasetClass = ''$CVReplicatedDBDatasetClass''
		,@StorageType = ''$CVReplicatedDBStorageType''
		,@PartitionType = ''None''
		,@DatasetNameSpace = ''$CVReplicatedDBNameSpace''
		,@DatasetName = ''$CVReplicatedDatasetName''
		,@DatasetDescription = ''''
		,@DatasetPath = ''$CVReplicatedDatasetPath''
		,@DatasetExternalVersionID = NULL
		,@DatasetIsCreated = 1
		,@DatasetIsEnabled = 1
		,@DatasetKey = @DK2 OUTPUT;

	SELECT @DK2;

END


DECLARE @DIK1 SMALLINT;

/*Add DITask  MULTIPLE SOURCES to $CVLakehouseDatasetName*/
EXEC [DIF].[AddDITask]
	@SourceDatasetKey = $MultipleSourcesDatasetKey
	,@DestinationDatasetKey = @DK1
	,@LoadType = ''Full Only''
	,@DITaskSourceFilterLogic = NULL
	,@DITaskWaterMarkLogic = NULL
	,@DITaskEnabled = 1
	,@SourceFilterLogicIsEnabled = 0
	,@DITask = @DIK1 OUTPUT;

 SELECT @DIK1;

/*SET NotebookPath*/
UPDATE T SET T.NotebookPath = ''$CVNotebookPath''
FROM [config].[DITask] T
WHERE DITaskKey = @DIK1;


DECLARE @DIK2 SMALLINT;

IF(@IsDeltaTableReplicatedToAzureSQL = 1)
BEGIN

	/*Add DITask LAKEHOUSE $CVLakehouseDatasetName to $CVReplicatedDatasetPath*/
	EXEC [DIF].[AddDITask]
		@SourceDatasetKey = @DK1
		,@DestinationDatasetKey = @DK2
		,@LoadType = ''Full Only''
		,@DITaskSourceFilterLogic = NULL
		,@DITaskWaterMarkLogic = NULL
		,@DITaskEnabled = 1
		,@SourceFilterLogicIsEnabled = 0
		,@DITask = @DIK2 OUTPUT;

	SELECT @DIK2;

END



/*AddDIGroupTask MULTIPLE SOURCES to $CVLakehouseDatasetName*/
EXEC [DIF].[AddDIGroupTask]
	@DIGroupKey = $CVRefinedToLakehouseDIGroupKey
	,@DITaskKey = @DIK1
	,@DIGroupTaskPriorityOrder = $ExecutionGroup
	,@PipelineKey = $CVPipelineKey
	,@RelatedDIGroupTaskKey = NULL;



IF(@IsDeltaTableReplicatedToAzureSQL = 1)
BEGIN

	/*AddDIGroupTask LAKEHOUSE $CVLakehouseDatasetName to $CVReplicatedDatasetPath*/	
	EXEC [DIF].[AddDIGroupTask]
		@DIGroupKey = $CVLakehouseToReplicatedDIGroupKey
		,@DITaskKey = @DIK2
		,@DIGroupTaskPriorityOrder = $ExecutionGroup
		,@PipelineKey = $CVPipelineKey
		,@RelatedDIGroupTaskKey = NULL;

 END
 
/*Set RelatedDIGroupTaskKey for $CVLakehouseDatasetName / $CVReplicatedDatasetPath */

DECLARE @DIGTK1 SMALLINT = (SELECT MAX(DIGroupTaskKey) FROM [config].[DIGroupTask] );


IF(@IsDeltaTableReplicatedToAzureSQL = 1)
BEGIN

	UPDATE GT SET GT.RelatedDIGroupTaskKey = @DIGTK1
	FROM [config].[DIGroupTask] GT
	WHERE DIGroupTaskKey = @DIGTK1 - 1;

END


';

DECLARE @ConfigureDatasetAndTaskSQL_Replaced VARCHAR(MAX) = @ConfigureDatasetAndTaskSQL_Master;


DECLARE MappingDetailCursor CURSOR FOR 
SELECT * 
FROM 
	#MappingDetail;

OPEN MappingDetailCursor  
FETCH NEXT FROM MappingDetailCursor INTO @CVDeltaTable,	@CVNotebookPath, @CVLakehouseSystemName,	@CVLakehouseRepositoryName,	@CVLakehouseDatasetClass,	@CVLakehouseStorageType,	@CVLakehouseNameSpace,	@CVLakehouseTopLevelFolder,	@CVLakehouseDatasetName,	@CVLakehouseDatasetPath,	@CVRefinedToLakehouseDIGroupKey,	@CVReplicatedDBSystemName,	@CVReplicatedDBRepositoryName,	@CVReplicatedDBDatasetClass,	@CVReplicatedDBStorageType,	@CVReplicatedDBNameSpace,	@CVReplicatedDatasetName,	@CVReplicatedDatasetPath,	@CVLakehouseToReplicatedDIGroupKey,	@CVPipelineKey, @CVIsDeltaTableReplicatedToAzureSQL;

WHILE @@FETCH_STATUS = 0  
BEGIN  
    
	/*  --uncomment this block to debug if needed
	SELECT
		CVDeltaTable = @CVDeltaTable,
		CVNotebookPath = @CVNotebookPath,
		CVLakehouseSystemName = @CVLakehouseSystemName,
		CVLakehouseRepositoryName = @CVLakehouseRepositoryName,
		CVLakehouseDatasetClass = @CVLakehouseDatasetClass,
		CVLakehouseStorageType = @CVLakehouseStorageType,
		CVLakehouseNameSpace = @CVLakehouseNameSpace,
		CVLakehouseTopLevelFolder = @CVLakehouseTopLevelFolder,
		CVLakehouseDatasetName = @CVLakehouseDatasetName,
		CVLakehouseDatasetPath = @CVLakehouseDatasetPath,
		CVRefinedToLakehouseDIGroupKey = @CVRefinedToLakehouseDIGroupKey,
		CVReplicatedDBSystemName = @CVReplicatedDBSystemName,
		CVReplicatedDBRepositoryName = @CVReplicatedDBRepositoryName,
		CVReplicatedDBDatasetClass = @CVReplicatedDBDatasetClass,
		CVReplicatedDBStorageType = @CVReplicatedDBStorageType,
		CVReplicatedDBNameSpace = @CVReplicatedDBNameSpace,
		CVReplicatedDatasetName = @CVReplicatedDatasetName,
		CVReplicatedDatasetPath = @CVReplicatedDatasetPath,
		CVLakehouseToReplicatedDIGroupKey = @CVLakehouseToReplicatedDIGroupKey,
		CVPipelineKey = @CVPipelineKey,
		CVIsDeltaTableReplicatedToAzureSQL = @CVIsDeltaTableReplicatedToAzureSQL;
		*/
	

	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$MultipleSourcesDatasetKey', @MultipleSourcesDatasetKey);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$ExecutionGroup', @ExecutionGroup);
	
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVDeltaTable', @CVDeltaTable);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVNotebookPath', @CVNotebookPath);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseSystemName', @CVLakehouseSystemName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseRepositoryName', @CVLakehouseRepositoryName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseDatasetClass', @CVLakehouseDatasetClass);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseStorageType', @CVLakehouseStorageType);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseNameSpace', @CVLakehouseNameSpace);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseTopLevelFolder', @CVLakehouseTopLevelFolder);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseDatasetName', @CVLakehouseDatasetName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseDatasetPath', @CVLakehouseDatasetPath);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVRefinedToLakehouseDIGroupKey', @CVRefinedToLakehouseDIGroupKey);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVReplicatedDBSystemName', @CVReplicatedDBSystemName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVReplicatedDBRepositoryName', @CVReplicatedDBRepositoryName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVReplicatedDBDatasetClass', @CVReplicatedDBDatasetClass);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVReplicatedDBStorageType', @CVReplicatedDBStorageType);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVReplicatedDBNameSpace', @CVReplicatedDBNameSpace);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVReplicatedDatasetName', @CVReplicatedDatasetName);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVReplicatedDatasetPath', @CVReplicatedDatasetPath);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVLakehouseToReplicatedDIGroupKey', @CVLakehouseToReplicatedDIGroupKey);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVPipelineKey', @CVPipelineKey);
	SET @ConfigureDatasetAndTaskSQL_Replaced = REPLACE(@ConfigureDatasetAndTaskSQL_Replaced, '$CVIsDeltaTableReplicatedToAzureSQL', @CVIsDeltaTableReplicatedToAzureSQL);
	


	SELECT ConfigureDatasetAndTaskSQL_Replaced = @ConfigureDatasetAndTaskSQL_Replaced;

	IF(@IsReadOnlyMode = 0)
	BEGIN
		EXEC(@ConfigureDatasetAndTaskSQL_Replaced);
	END

	FETCH NEXT FROM MappingDetailCursor INTO @CVDeltaTable,	@CVNotebookPath, @CVLakehouseSystemName,	@CVLakehouseRepositoryName,	@CVLakehouseDatasetClass,	@CVLakehouseStorageType,	@CVLakehouseNameSpace,	@CVLakehouseTopLevelFolder,	@CVLakehouseDatasetName,	@CVLakehouseDatasetPath,	@CVRefinedToLakehouseDIGroupKey,	@CVReplicatedDBSystemName,	@CVReplicatedDBRepositoryName,	@CVReplicatedDBDatasetClass,	@CVReplicatedDBStorageType,	@CVReplicatedDBNameSpace,	@CVReplicatedDatasetName,	@CVReplicatedDatasetPath,	@CVLakehouseToReplicatedDIGroupKey,	@CVPipelineKey, @CVIsDeltaTableReplicatedToAzureSQL 

	SET @ConfigureDatasetAndTaskSQL_Replaced = @ConfigureDatasetAndTaskSQL_Master;
END 

CLOSE MappingDetailCursor  
DEALLOCATE MappingDetailCursor 



