


CREATE   PROCEDURE [DIF].[AddSystem]
	(
	@SystemType VARCHAR(50)
	,@EnvironmentType VARCHAR(50)
	,@SystemName VARCHAR(50)
	,@SystemDescription VARCHAR(255) = NULL
	,@SystemProgram VARCHAR(50) = NULL
	,@SystemFQDN VARCHAR(255)
	,@SystemUserName VARCHAR(255) = NULL
	,@SystemSecretName VARCHAR(255) = NULL
	,@SystemIsEnabled BIT
	,@SystemKey SMALLINT OUTPUT
	)
AS

/*

SP Name:  [DIF].[AddSystem]
Purpose:  Used to add a new system (server, source/destination system, etc.)
Parameters:
	@SystemType - provides the system type (RDBMS, File Server, etc.)
	@EnvironmentType - provides the environment type (Development, Staging, Production, etc.)
	@SystemName - indicates the system name (can be a shortened name that is recognizable)
	@SystemDescription - (optional) provides a system description
	@SystemProgram - (optional) indicates the  program the system belongs to
	@SystemFQDN - lists the fully-qualified domain name for the system
	@SystemUserName - (optional) provides a user name for making a connection to the system
	@SystemSecretName - (optional) provides a key valued secret name for making a connection to the system
	@SystemIsEnabled - indicates whether the system is enabled for data integration tasks

Test harnass:

SELECT * FROM [reference].[SystemType]
SELECT * FROM [reference].[EnvironmentType]
SELECT * FROM [metadata].[System]

DECLARE @SK SMALLINT

EXEC [DIF].[AddSystem]
	@SystemType = 'RDBMS'
	,@EnvironmentType = 'Production'
	,@SystemName = 'Test'
	,@SystemDescription = 'Test system'
	,@SystemProgram = 'DW'
	,@SystemFQDN = 'https://steimdeveastus001.dfs.core.windows.net/'
--	,@SystemUserName
--	,@SystemSecretName
	,@SystemIsEnabled = 1
	,@SystemKey = @SK OUTPUT

SELECT @SK

*/

BEGIN

DECLARE
	@SystemTypeKey SMALLINT
	,@EnvironmentTypeKey SMALLINT
	,@SystemKeyCheck INT;

BEGIN TRY

SELECT
	@SystemTypeKey = a.[SystemTypeKey]
FROM
	[reference].[SystemType] AS a
WHERE
	a.[SystemType] = @SystemType;

IF @SystemTypeKey IS NULL
	THROW 50101, 'An unknown system type was identified by the @SystemType parameter.', 1;

SELECT
	@EnvironmentTypeKey = a.[EnvironmentTypeKey]
FROM
	[reference].[EnvironmentType] AS a
WHERE
	a.[EnvironmentType] = @EnvironmentType;

IF @EnvironmentTypeKey IS NULL
	THROW 50102, 'An unknown environment type was identified by the @EnvironmentType parameter.', 1;

SELECT
	@SystemKeyCheck = a.[SystemKey]
FROM
	[metadata].[System] AS a
WHERE
	a.[SystemName] = @SystemName;

IF @SystemKeyCheck IS NOT NULL
	THROW 50103, 'The system specified by the @SystemName parameter already exists.', 1;

SELECT
	@SystemKeyCheck = a.[SystemKey]
FROM
	[metadata].[System] AS a
WHERE
	a.[SystemFQDN] = @SystemFQDN;

IF @SystemKeyCheck IS NOT NULL
	THROW 50104, 'The system specified by the @SystemFQDN parameter already exists.', 1;

INSERT INTO [metadata].[System]
	(
	[SystemTypeKey]
	,[EnvironmentTypeKey]
	,[SystemName]
	,[SystemDescription]
	,[SystemProgram]
	,[SystemFQDN]
	,[SystemUserName]
	,[SystemSecretName]
	,[SystemIsEnabled]
	)
VALUES
	(
	@SystemTypeKey
	,@EnvironmentTypeKey
	,@SystemName
	,@SystemDescription
	,@SystemProgram
	,@SystemFQDN
	,@SystemUserName
	,@SystemSecretName
	,@SystemIsEnabled
	);

SET @SystemKey = SCOPE_IDENTITY();


END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

