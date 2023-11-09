


CREATE   PROCEDURE [DIF].[SetEnvironmentConfig]
	(
	@ProjectName VARCHAR(50)
	,@EnvironmentConfigName VARCHAR(255)
	,@EnvironmentConfigValue VARCHAR(255)
	)
AS

/*

SP Name:  [DIF].[SetEnvironmentConfig]
Purpose:  Used to set (add or update) an environment config entry for a given project
Parameters:
	@ProjectName - provides the name of the project the environment config entry belongs to
	@EnvironmentConfigName - provides the environment config entry name
	@EnvironmentConfigValue - provides the environment config entry value

Test harnass:

SELECT * FROM [config].[Project]
SELECT * FROM [config].[EnvironmentConfig]

EXEC [DIF].[SetEnvironmentConfig]
	@ProjectName = 'Test SQL Server Ingestion Framework'
	,@EnvironmentConfigName = 'DataLake_SecretName'
	,@EnvironmentConfigValue = 'data-lake-access-key'

*/

BEGIN

DECLARE
	@ProjectKey SMALLINT
	,@EnvironmentConfigKey SMALLINT;

BEGIN TRY

SELECT
	@ProjectKey = a.[ProjectKey]
FROM
	[config].[Project] AS a
WHERE
	a.[ProjectName] = @ProjectName;

IF @ProjectKey IS NULL
	THROW 50101, 'An unknown project name was identified by the @ProjectName parameter.', 1;

SELECT
	@EnvironmentConfigKey = a.[EnvironmentConfigKey]
FROM
	[config].[EnvironmentConfig] AS a
WHERE
	a.[ProjectKey] = @ProjectKey
	AND a.[EnvironmentConfigName] = @EnvironmentConfigName;

IF @EnvironmentConfigKey IS NULL
	INSERT INTO [config].[EnvironmentConfig]
		(
		[ProjectKey]
		,[EnvironmentConfigName]
		,[EnvironmentConfigValue]
		)
	VALUES
		(
		@ProjectKey
		,@EnvironmentConfigName
		,@EnvironmentConfigValue
		);
ELSE
	UPDATE
		a
	SET
		a.[EnvironmentConfigValue] = @EnvironmentConfigValue
	FROM
		[config].[EnvironmentConfig] AS a
	WHERE
		a.[EnvironmentConfigKey] = @EnvironmentConfigKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

