
CREATE   PROCEDURE [DIF].[UpdateDataset]
	(
	@DatasetKey SMALLINT
	,@SystemName VARCHAR(50) = NULL
	,@RepositoryName VARCHAR(50) = NULL
	,@DatasetClass VARCHAR(50) = NULL
	,@StorageType VARCHAR(50) = NULL
	,@PartitionType VARCHAR(50) = NULL
	,@DatasetNameSpace VARCHAR(255) = NULL
	,@DatasetName VARCHAR(255) = NULL
	,@DatasetDescription VARCHAR(255) = NULL
	,@DatasetPath VARCHAR(255) = NULL
	,@DatasetExternalVersionID VARCHAR(50) = NULL
	,@DatasetIsCreated BIT = NULL
	,@DatasetIsEnabled BIT = NULL
	)
AS

/*

SP Name:  [DIF].[UpdateDataset]
Purpose:  Used to update a dataset (table, view, data lake storage folder, etc.)
Parameters:
	@DatasetKey - identifies the dataset to be updated
	@SystemName - (optional) identifies the new parent system (this and @RepositoryName must be supplied as a pair)
	@RepositoryName - (optional) indicates the new parent repository (this and @SystemName must be supplied as a pair)
	@DatasetClass - (optional) provides the new dataset class
	@StorageType - (optional) provides the new storage type
	@PartitionType - (optional) provides the new partition type
	@DatasetNameSpace - (optional) indicates the new dataset name space
	@DatasetName - (optional) provides the new dataset name
	@DatasetDescription - (optional) provides the new dataset description
	@DatasetPath - (optional) indicates the new dataset path
	@DatasetExternalVersionID - (optional) provides the new external version ID for the dataset
	@DatasetIsCreated - (optional) provides the new "is created" status for the dataset
	@DatasetIsEnabled - (optional) provides the new enabled status for the dataset

Special note:  A special value of 'NULL' can be passed in for the following parameters in order
to set the associated columns to NULL since those columns are nullable in the [metadata].[Dataset] table:
	@DatasetNameSpace
	@DatasetDescription
	DatasetExternalVersionID

Test harnass:

SELECT * FROM [metadata].[System]
SELECT * FROM [metadata].[Repository]
SELECT * FROM [reference].[DatasetClass]
SELECT * FROM [reference].[StorageType]
SELECT * FROM [reference].[PartitionType]
SELECT * FROM [metadata].[Dataset] where [DatasetKey] = 31

EXEC [DIF].[UpdateDataset]
	@DatasetKey = 31
	,@SystemName = 'dbserver'
	,@RepositoryName = 'testdb'
	,@DatasetClass = 'Dimension'
	,@StorageType = 'Relational View'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'Dim'
	,@DatasetName = 'TestDim'
	,@DatasetDescription = 'Dimension in DW for...'
	,@DatasetPath = 'Dim.TestDim'
	,@DatasetExternalVersionID = '8'
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1

*/

BEGIN

DECLARE
	@RepositoryKey SMALLINT
	,@DatasetClassKey SMALLINT
	,@StorageTypeKey SMALLINT
	,@PartitionTypeKey SMALLINT;

BEGIN TRY

IF (@SystemName IS NOT NULL AND @RepositoryName IS NULL) OR (@SystemName IS NULL AND @RepositoryName IS NOT NULL)
	THROW 50101, 'Both the @SystemName and @RepositoryName parameters must be specified together if either is specified.', 1;
ELSE
	IF (@SystemName IS NOT NULL AND @RepositoryName IS NOT NULL)

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

IF @DatasetClass IS NOT NULL
	BEGIN

	SELECT
		@DatasetClassKey = a.[DatasetClassKey]
	FROM
		[reference].[DatasetClass] AS a
	WHERE
		a.[DatasetClass] = @DatasetClass;

	IF @DatasetClassKey IS NULL
		THROW 50103, 'An unknown dataset class was identified by the @DatasetClass parameter.', 1;

	END

IF @StorageType IS NOT NULL
	BEGIN

	SELECT
		@StorageTypeKey = a.[StorageTypeKey]
	FROM
		[reference].[StorageType] AS a
	WHERE
		a.[StorageType] = @StorageType;

	IF @StorageTypeKey IS NULL
		THROW 50104, 'An unknown storage type was identified by the @StorageType parameter.', 1;

	END

IF @PartitionType IS NOT NULL
	BEGIN

	SELECT
		@PartitionTypeKey = a.[PartitionTypeKey]
	FROM
		[reference].[PartitionType] AS a
	WHERE
		a.[PartitionType] = @PartitionType;

	IF @PartitionTypeKey IS NULL
		THROW 50105, 'An unknown partition type was identified by the @PartitionType parameter.', 1;

	END

UPDATE
	a
SET
	[DatasetClassKey] = ISNULL(@DatasetClassKey, a.[DatasetClassKey])
	,[StorageTypeKey] = ISNULL(@StorageTypeKey, a.[StorageTypeKey])
	,[PartitionTypeKey] = ISNULL(@PartitionTypeKey, a.[PartitionTypeKey])
	,[RepositoryKey] = ISNULL(@RepositoryKey, a.[RepositoryKey])
	,[DatasetNameSpace] =
		CASE
			WHEN @DatasetNameSpace = 'NULL' THEN NULL
			ELSE ISNULL(@DatasetNameSpace, a.[DatasetNameSpace])
		END
	,[DatasetName] = ISNULL(@DatasetName, a.[DatasetName])
	,[DatasetDescription] =
		CASE
			WHEN @DatasetDescription = 'NULL' THEN NULL
			ELSE ISNULL(@DatasetDescription, a.[DatasetDescription])
		END
	,[DatasetPath] = ISNULL(@DatasetPath, a.[DatasetPath])
	,[DatasetExternalVersionID] =
		CASE
			WHEN @DatasetExternalVersionID = 'NULL' THEN NULL
			ELSE ISNULL(@DatasetExternalVersionID, a.[DatasetExternalVersionID])
		END
	,[DatasetIsCreated] = ISNULL(@DatasetIsCreated, a.[DatasetIsCreated])
	,[DatasetIsEnabled] = ISNULL(@DatasetIsEnabled, a.[DatasetIsEnabled])
FROM
	[metadata].[Dataset] AS a
WHERE
	a.[DatasetKey] = @DatasetKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

