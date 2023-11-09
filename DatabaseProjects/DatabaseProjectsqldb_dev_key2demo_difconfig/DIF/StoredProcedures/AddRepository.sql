


CREATE   PROCEDURE [DIF].[AddRepository]
	(
	@SystemName VARCHAR(50) = NULL
	,@RepositoryType VARCHAR(50)
	,@RepositoryName VARCHAR(50)
	,@RepositoryDescription VARCHAR(255) = NULL
	,@RepositoryPathPattern VARCHAR(255) = NULL
	,@RepositoryIsEnabled BIT
	,@RepositoryKey SMALLINT OUTPUT
	)
AS

/*

SP Name:  [DIF].[AddRepository]
Purpose:  Used to add a new repository (database, folder name, etc.)
Parameters:
	@SystemName - (optional) identifies the parent system (this or @SystemKey is required)
	@RepositoryType - provides the repository type (SQL Server Database, Windows Fileshare, etc.)
	@RepositoryName - provides the name of the repository
	@RepositoryDescription - (optional) provides a repository description
	@RepositoryPathPattern - (optional) indicates the pattern for accessing a dataset within the repository
	@RepositoryIsEnabled - indicates whether the repository is enabled for data integration tasks

Test harnass:

SELECT * FROM [reference].[RepositoryType]
SELECT * FROM [metadata].[System]
SELECT * FROM [metadata].[Repository]

DECLARE @RK SMALLINT 

EXEC [DIF].[AddRepository]
	@SystemName = 'Test'
	,@RepositoryType = 'SQL Server Database'
	,@RepositoryName = 'TEST'
	,@RepositoryDescription = 'Test repository'
	,@RepositoryPathPattern = '[database].[schema].[table]'
	,@RepositoryIsEnabled = 0
	,@RepositoryKey = @RK OUTPUT

SELECT @RK

*/

BEGIN

DECLARE
	@SystemKey SMALLINT
	,@RepositoryTypeKey SMALLINT

BEGIN TRY

SELECT
	@SystemKey = a.[SystemKey]
FROM
	[metadata].[System] AS a
WHERE
	a.[SystemName] = @SystemName;

IF @SystemKey IS NULL
	THROW 50101, 'The system specified by the @SystemName parameter does not exist.', 1;

SELECT
	@RepositoryTypeKey = a.[RepositoryTypeKey]
FROM
	[reference].[RepositoryType] AS a
WHERE
	a.[RepositoryType] = @RepositoryType;

IF @RepositoryTypeKey IS NULL
	THROW 50105, 'An unknown repository type was identified by the @RepositoryType parameter.', 1;

INSERT INTO [metadata].[Repository]
	(
	[SystemKey]
	,[RepositoryTypeKey]
	,[RepositoryName]
	,[RepositoryDescription]
	,[RepositoryPathPattern]
	,[RepositoryIsEnabled]
	)
VALUES
	(
	@SystemKey
	,@RepositoryTypeKey
	,@RepositoryName
	,@RepositoryDescription
	,@RepositoryPathPattern
	,@RepositoryIsEnabled
	);

SET @RepositoryKey = SCOPE_IDENTITY();

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

