

CREATE   PROCEDURE [DIF].[UpdateSystem]
	(
	@SystemKey SMALLINT
	,@SystemType VARCHAR(50) = NULL
	,@EnvironmentType VARCHAR(50) = NULL
	,@SystemName VARCHAR(50) = NULL
	,@SystemDescription VARCHAR(255) = NULL
	,@SystemProgram VARCHAR(50) = NULL
	,@SystemFQDN VARCHAR(255) = NULL
	,@SystemUserName VARCHAR(255) = NULL
	,@SystemSecretName VARCHAR(255) = NULL
	,@SystemIsEnabled BIT = NULL
	)
AS

/*

SP Name:  [DIF].[UpdateSystem]
Purpose:  Used to update a system (server, source/destination system, etc.)
Parameters:
	@SystemKey - identifies the system to be updated
	@SystemType - (optional) provides the new system type
	@EnvironmentType - (optional) provides the new environment type
	@SystemName - (optional) indicates the new system name
	@SystemDescription - (optional) provides the new system description
	@SystemProgram - (optional) indicates the new VA/VHA/VBA program the system belongs to
	@SystemFQDN - (optional) lists the new fully-qualified domain name for the system
	@SystemUserName - (optional) provides the new user name for making a connection to the system
	@SystemSecretName - (optional) provides the new key vault secret name for making a connection to the system
	@SystemIsEnabled - (optional) provides the new enabled status for the system

Special note:  A special value of 'NULL' can be passed in for the following parameters in order
	to set the associated columns to NULL since those columns are nullable in the [metadata].[System] table:
	@SystemDescription
	@SystemProgram
	@SystemUserName
	@SystemSecretName

Test harnass:

SELECT * FROM [reference].[SystemType]
SELECT * FROM [reference].[EnvironmentType]
SELECT * FROM [metadata].[System]

EXEC [DIF].[UpdateSystem]
	@SystemKey = 10
	,@SystemType = 'RDBMS'
	,@EnvironmentType = 'Development'
	,@SystemName = 'steimdeveastus001'
	,@SystemDescription = 'Azure VM running SQL Server, loaded with DW data as a typical DW enclave'
	,@SystemProgram = 'DW'
	,@SystemFQDN = 'https://steimdeveastus001.dfs.core.windows.net/'
	,@SystemUserName = 'NULL'
	,@SystemSecretName = 'NULL'
	,@SystemIsEnabled = 0

*/

BEGIN

DECLARE
	@SystemTypeKey SMALLINT
	,@EnvironmentTypeKey SMALLINT
	,@SystemKeyCheck INT;

BEGIN TRY

SELECT
	@SystemKeyCheck = a.[SystemKey]
FROM
	[metadata].[System] AS a
WHERE
	a.[SystemKey] = @SystemKey;

IF @SystemKeyCheck IS NULL
	THROW 50101, 'An unknown system was identified by the @SystemKey parameter.', 1;

IF @SystemType IS NOT NULL
	BEGIN

	SELECT
		@SystemTypeKey = a.[SystemTypeKey]
	FROM
		[reference].[SystemType] AS a
	WHERE
		a.[SystemType] = @SystemType;

	IF @SystemTypeKey IS NULL
		THROW 50102, 'An unknown system type was identified by the @SystemType parameter.', 1;

	END

IF @EnvironmentType IS NOT NULL
	BEGIN

	SELECT
		@EnvironmentTypeKey = a.[EnvironmentTypeKey]
	FROM
		[reference].[EnvironmentType] AS a
	WHERE
		a.[EnvironmentType] = @EnvironmentType;

	IF @EnvironmentTypeKey IS NULL
		THROW 50102, 'An unknown environment type was identified by the @EnvironmentType parameter.', 1;

	END

UPDATE
	a
SET
	a.[SystemTypeKey] = ISNULL(@SystemTypeKey, a.[SystemTypeKey])
	,[EnvironmentTypeKey] = ISNULL(@EnvironmentTypeKey, a.[EnvironmentTypeKey])
	,[SystemName] = ISNULL(@SystemName, a.[SystemName])
	,[SystemDescription] =
		CASE
			WHEN @SystemDescription = 'NULL' THEN NULL
			ELSE ISNULL(@SystemDescription, a.[SystemDescription])
		END
	,[SystemProgram] =
		CASE
			WHEN @SystemProgram = 'NULL' THEN NULL
			ELSE ISNULL(@SystemProgram, a.[SystemProgram])
		END
	,[SystemFQDN] = ISNULL(@SystemFQDN, a.[SystemFQDN])
	,[SystemUserName] = 
		CASE
			WHEN @SystemUserName = 'NULL' THEN NULL
			ELSE ISNULL(@SystemUserName, a.[SystemUserName])
		END
	,[SystemSecretName] = 
		CASE
			WHEN @SystemSecretName = 'NULL' THEN NULL
			ELSE ISNULL(@SystemSecretName, a.[SystemSecretName])
		END
	,[SystemIsEnabled] = ISNULL(@SystemIsEnabled, a.[SYstemIsEnabled])
FROM
	[metadata].[System] AS a
WHERE
	a.[SystemKey] = @SystemKey;

END TRY

BEGIN CATCH

THROW;

END CATCH

END

GO

