







CREATE   PROCEDURE [DIF].[AddDataset]
	(
	@SystemName VARCHAR(50)
	,@RepositoryName VARCHAR(50)
	,@DatasetClass VARCHAR(50)
	,@StorageType VARCHAR(50)
	,@PartitionType VARCHAR(50) = 'None'
	,@DatasetNameSpace VARCHAR(255) = NULL
	,@DatasetName VARCHAR(255)
	,@DatasetDescription VARCHAR(255) = NULL
	,@DatasetPath VARCHAR(255)
	,@DatasetExternalVersionID VARCHAR(50) = NULL
	,@DatasetIsCreated BIT
	,@DatasetIsEnabled BIT
	,@DatasetKey SMALLINT OUTPUT
	)
AS

/*

SP Name:  [DIF].[AddDataset]
Purpose:  Used to add a new dataset (table, view, storage account folder, etc.)
Parameters:
	@SystemName - identifies the parent system
	@RepositoryName - identifies the parent repository
	@StorageType - provides the storage type for the dataset
	@PartitionType - provides the partition type (with a default of "None")
	@DatasetNameSpace - (optional) provides the dataset name space (i.e., schema for a table or view)
	@DatasetName - provides the name of the dataset (within the associated repository)
	@DatasetDescription - (optional) provides a dataset description
	@DatasetPath - provides the path to the dataset (i.e., <schema>.<name>, \<parentfolder>\<subfolder>, etc.)
	@DatasetExternalVersionID - (optional) provides a version identifier if one is available
	@DatasetIsCreated - indicates if the dataset already exists
	@DatasetIsEnabled - indicates if the dataset is enabled for data integration tasks

Test harnass:

SELECT * FROM [metadata].[System]
SELECT * FROM [metadata].[Repository]
SELECT * FROM [reference].[DatasetClass]
SELECT * FROM [reference].[StorageType]
SELECT * FROM [reference].[PartitionType]
SELECT * FROM [metadata].[Dataset] where [DatasetName] = 'DrugClass'
----SELECT * FROM [reference].[DatasetType]

DECLARE @DK SMALLINT

EXEC [DIF].[AddDataset]
	@SystemName = 'TestServer'
	,@RepositoryName = 'TestDB'
	,@DatasetClass = 'Dimension'
	,@StorageType = 'Relational View'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'Dim'
	,@DatasetName = 'TestTable'
	,@DatasetDescription = 'Test table for config setup'
	,@DatasetPath = 'Dim.TestTable'
	,@DatasetExternalVersionID = '8'
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK

*/

BEGIN

DECLARE
	@RepositoryKey SMALLINT
	,@DatasetClassKey SMALLINT
	--,@DatasetTypeKey SMALLINT
	,@StorageTypeKey SMALLINT
	,@PartitionTypeKey SMALLINT
	,@DatasetInternalVersionID SMALLINT;

BEGIN TRY

IF (@SystemName IS NULL OR @RepositoryName IS NULL)
	THROW 50101, 'Both the @SystemName and @RepositoryName parameters must be specified.', 1;
ELSE
	BEGIN

	SELECT
		@RepositoryKey = a.[RepositoryKey]
	FROM
		[metadata].[Repository] AS a
		INNER JOIN [metadata].[System] AS b ON
			a.[SystemKey] = b.[SystemKey]
	WHERE
		b.[SystemName] = @SystemName
		AND a.[RepositoryName] = @RepositoryName;

	IF @RepositoryKey IS NULL
		THROW 50102, 'The @SystemName and @RepositoryName parameters do not refer to a valid repository.', 1;

	END

SELECT
	@DatasetClassKey = a.[DatasetClassKey]
FROM
	[reference].[DatasetClass] AS a
WHERE
	a.[DatasetClass] = @DatasetClass;

IF @DatasetClassKey IS NULL
	THROW 50105, 'An unknown dataset class was identified by the @DatasetClass parameter.', 1;


SELECT
	@StorageTypeKey = a.[StorageTypeKey]
FROM
	[reference].[StorageType] AS a
WHERE
	a.[StorageType] = @StorageType;

IF @StorageTypeKey IS NULL
	THROW 50105, 'An unknown storage type was identified by the @StorageType parameter.', 1;

SELECT
	@PartitionTypeKey = a.[PartitionTypeKey]
FROM
	[reference].[PartitionType] AS a
WHERE
	a.[PartitionType] = @PartitionType;

IF @PartitionTypeKey IS NULL
	THROW 50105, 'An unknown partition type was identified by the @PartitionType parameter.', 1;

SELECT
	@DatasetInternalVersionID = a.[DatasetInternalVersionID]
FROM
	[metadata].[Dataset] AS a
WHERE
	a.[RepositoryKey] = @RepositoryKey
	AND a.[DatasetNameSpace] = @DatasetNameSpace
	AND a.[DatasetName] = @DatasetName
	AND a.[DatasetIsLatestVersion] = 1;

IF @DatasetInternalVersionID IS NULL
BEGIN
	INSERT INTO [metadata].[Dataset]
		(
		[DatasetClassKey]
		,[StorageTypeKey]
		,[PartitionTypeKey]
		,[RepositoryKey]
		,[DatasetNameSpace]
		,[DatasetName]
		,[DatasetDescription]
		,[DatasetPath]
		,[DatasetInternalVersionID]
		,[DatasetExternalVersionID]
		,[DatasetIsLatestVersion]
		,[DatasetIsCreated]
		,[DatasetIsEnabled]
		)
	VALUES
		(
		@DatasetClassKey
		,@StorageTypeKey
		,@PartitionTypeKey
		,@RepositoryKey
		,@DatasetNameSpace
		,@DatasetName
		,@DatasetDescription
		,@DatasetPath
		,1
		,@DatasetExternalVersionID
		,1
		,@DatasetIsCreated
		,@DatasetIsEnabled
		);

	SET @DatasetKey = SCOPE_IDENTITY();

END
ELSE
	BEGIN

	BEGIN TRAN;

	UPDATE
		a
	SET
		[DatasetIsLatestVersion] = 0
	FROM
		[metadata].[Dataset] AS a
	WHERE
		a.[RepositoryKey] = @RepositoryKey
		AND a.[DatasetNameSpace] = @DatasetNameSpace
		AND a.[DatasetName] = @DatasetName
		AND a.[DatasetIsLatestVersion] = 1;

	INSERT INTO [metadata].[Dataset]
		(
		[DatasetClassKey]
		,[StorageTypeKey]
		,[PartitionTypeKey]
		,[RepositoryKey]
		,[DatasetNameSpace]
		,[DatasetName]
		,[DatasetDescription]
		,[DatasetPath]
		,[DatasetInternalVersionID]
		,[DatasetExternalVersionID]
		,[DatasetIsLatestVersion]
		,[DatasetIsCreated]
		,[DatasetIsEnabled]
		)
	VALUES
		(
		@DatasetClassKey
		,@StorageTypeKey
		,@PartitionTypeKey
		,@RepositoryKey
		,@DatasetNameSpace
		,@DatasetName
		,@DatasetDescription
		,@DatasetPath
		,@DatasetInternalVersionID + 1
		,@DatasetExternalVersionID
		,1
		,@DatasetIsCreated
		,@DatasetIsEnabled
		);

	SET @DatasetKey = SCOPE_IDENTITY();

	COMMIT TRAN;

	END

END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

