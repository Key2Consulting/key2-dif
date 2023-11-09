



----Add Pipeline: PL_DIF_Lakehouse_GroupOrder--
DECLARE @PK SMALLINT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'EIA-Electricity Generation'
	,@PipelineShortName = 'PL_DIF_Lakehouse_GroupOrder'
	,@PipelineFullName = 'PL_DIF_Lakehouse_GroupOrder'
	,@PipelineFolder = 'DIF Lakehouse'
	,@PipelineDescription = 'PL_DIF_Lakehouse_GroupOrder'
	,@PipelineKey = @PK OUTPUT

SELECT @PK  
GO


----Add Pipeline: PL_DIF_Lakehouse_TaskLoop
DECLARE @PK SMALLINT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'EIA-Electricity Generation'
	,@PipelineShortName = 'PL_DIF_Lakehouse_TaskLoop'
	,@PipelineFullName = 'PL_DIF_Lakehouse_TaskLoop'
	,@PipelineFolder = 'DIF Lakehouse'
	,@PipelineDescription = 'PL_DIF_Lakehouse_TaskLoop'
	,@PipelineKey = @PK OUTPUT

SELECT @PK  
GO


----Add Pipeline: PL_DIF_Lakehouse_Ingestion
DECLARE @PK SMALLINT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'EIA-Electricity Generation'
	,@PipelineShortName = 'PL_DIF_Lakehouse_Ingestion'
	,@PipelineFullName = 'PL_DIF_Lakehouse_Ingestion'
	,@PipelineFolder = 'DIF Lakehouse'
	,@PipelineDescription = 'PL_DIF_Lakehouse_Ingestion'
	,@PipelineKey = @PK OUTPUT

SELECT @PK  
GO


----Add AddDIGroup----
DECLARE @DK SMALLINT

EXEC [DIF].[AddDIGroup]
	@DIGroupName = 'EIA-ElecGen-Gold Zone Merge'
	,@ProjectName = 'EIA-Electricity Generation'
	,@DIGroupIsEnabled = 1
	,@DIGroupKey = @DK OUTPUT

SELECT @DK  
GO



----Add Dataset Multiple Sources---- (in silver zone)
DECLARE @DK SMALLINT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'silverzone'  
	,@DatasetClass = 'Reference Table'
	,@StorageType = 'Databricks Delta Table'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'Multiple Sources'
	,@DatasetName = 'Multiple Sources'
	,@DatasetDescription = 'Multiple Sources'
	,@DatasetPath = 'n/a'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK  
GO

----Add DESTINATION Repository: goldzone----
DECLARE @RK SMALLINT 

EXEC [DIF].[AddRepository]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryType = 'Azure Data Lake Zone'
	,@RepositoryName = 'goldzone'
	,@RepositoryDescription = 'Key2 Demo datalake goldzone'
	,@RepositoryPathPattern = NULL
	,@RepositoryIsEnabled = 1
	,@RepositoryKey = @RK OUTPUT

SELECT @RK




