


CREATE   PROCEDURE [DIF].[UpdateRepository]
	(
	@RepositoryKey SMALLINT
	,@SystemName VARCHAR(50) = NULL
	,@RepositoryType VARCHAR(50) = NULL
	,@RepositoryName VARCHAR(50) = NULL
	,@RepositoryDescription VARCHAR(255) = NULL
	,@RepositoryPathPattern VARCHAR(50) = NULL
	,@RepositoryIsEnabled BIT = NULL
	)
AS

/*

SP Name:  [DIF].[UpdateRepository]
Purpose:  Used to update a repository (database, folder name, etc.)
Parameters:
	@RepositoryKey - identifies the repository to be updated
	@SystemName - (optional) identifies the parent system
	@RepositoryType - (optional) provides the new repository type
	@RepositoryName - (optional) indicates the new repository name
	@RepositoryDescription - (optional) provides the new repository description
	@@RepositoryPathPattern - (optional) indicates the new repository path pattern
	@RepositoryIsEnabled - (optional) provides the new enabled status for the repository

Special note:  A special value of 'NULL' can be passed in for the following parameters in order
to set the associated columns to NULL since those columns are nullable in the [metadata].[Repository] table:
	@RepositoryDescription
	@RepositoryPathPattern

Test harnass:

SELECT * FROM [reference].[RepositoryType]
SELECT * FROM [metadata].[System]
SELECT * FROM [metadata].[Repository]

EXEC [DIF].[UpdateRepository]
	@RepositoryKey = 10
	,@SystemName = 'steimdeveastus001'
	,@RepositoryType = 'SQL Server Database'
	,@RepositoryName = 'TestDB'
	,@RepositoryDescription = 'TestDB is the database that represents the WYSIWYG version of data from across the country'
	,@RepositoryPathPattern = '[database].[schema].[table]'
	,@RepositoryIsEnabled = 1

*/

BEGIN

DECLARE
	@SystemKey INT
	,@RepositoryTypeKey SMALLINT;

BEGIN TRY

IF @SystemName IS NOT NULL
	BEGIN

	SELECT
		@SystemKey = a.[SystemKey]
	FROM
		[metadata].[System] AS a
	WHERE
		a.[SystemName] = @SystemName;

	IF @SystemKey IS NULL
		THROW 50103, 'The system specified by the @SystemName parameter does not exist.', 1;

	END

IF @RepositoryType IS NOT NULL
	BEGIN

	SELECT
		@RepositoryTypeKey = a.[RepositoryTypeKey]
	FROM
		[reference].[RepositoryType] AS a
	WHERE
		a.[RepositoryType] = @RepositoryType;

	IF @RepositoryTypeKey IS NULL
		THROW 50104, 'An unknown repository type was identified by the @RepositoryType parameter.', 1;

	END

UPDATE
	a
SET
	a.[SystemKey] = ISNULL(@SystemKey, a.[SystemKey])
	,[RepositoryTypeKey] = ISNULL(@RepositoryTypeKey, a.[RepositoryTypeKey])
	,[RepositoryName] = ISNULL(@RepositoryName, a.[RepositoryName])
	,[RepositoryDescription] =
		CASE
			WHEN @RepositoryDescription = 'NULL' THEN NULL
			ELSE ISNULL(@RepositoryDescription, a.[RepositoryDescription])
		END
	,[RepositoryPathPattern] =
		CASE
			WHEN @RepositoryPathPattern = 'NULL' THEN NULL
			ELSE ISNULL(@RepositoryPathPattern, a.[RepositoryPathPattern])
		END
	,[RepositoryIsEnabled] = ISNULL(@RepositoryIsEnabled, a.[RepositoryIsEnabled])
FROM
	[metadata].[Repository] AS a
WHERE
	a.[RepositoryKey] = @RepositoryKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

