--Verificar se Polybase está instalado
SELECT SERVERPROPERTY ('IsPolyBaseInstalled') AS IsPolyBaseInstalled
GO

--Habilitar o Polybase
exec sp_configure @configname = 'polybase enabled', @configvalue = 1
GO
RECONFIGURE
GO

--Criar banco de dados de teste
CREATE DATABASE BDTeste
GO

USE BDTeste
GO

--Criar e abrir a master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '23987hxJ#KL95234nl0zBe';
GO
OPEN MASTER KEY DECRYPTION BY PASSWORD = '23987hxJ#KL95234nl0zBe';
GO

--Criar credencial para acessar o data source
CREATE DATABASE SCOPED CREDENTIAL SqlServerCredentials
WITH IDENTITY = 'username', SECRET = 'password'
GO

--Criar o usuário na instância remota
USE [master]
GO
CREATE LOGIN [username] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [AdventureWorks2019]
GO
CREATE USER [username] FOR LOGIN [username]
GO
USE [AdventureWorks2019]
GO
ALTER ROLE [db_datareader] ADD MEMBER [username]
GO
USE [AdventureWorks2019]
GO
ALTER ROLE [db_owner] ADD MEMBER [username]
GO


--Criar a fonte de dados externa
CREATE EXTERNAL DATA SOURCE SQLServerInstance
    WITH ( LOCATION = 'sqlserver://SERVER-GU',
    PUSHDOWN = ON,
    CREDENTIAL = SQLServerCredentials);


--Escolher a tabela de outro instância 
--Criar a tabela externa
CREATE EXTERNAL TABLE dbo.Ext_SalesPerson(
	[BusinessEntityID] [int] NOT NULL,
	[TerritoryID] [int] NULL,
	[SalesQuota] [money] NULL,
	[Bonus] [money] NOT NULL,
	[CommissionPct] [smallmoney] NOT NULL,
	[SalesYTD] [money] NOT NULL,
	[SalesLastYear] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
      )
      WITH (
      LOCATION='AdventureWorks2019.Sales.SalesPerson',
      DATA_SOURCE=SqlServerInstance
     );

--Usar a tabela externa normalmente nos SELECTs
SELECT *
FROM dbo.Ext_SalesPerson

--OBS.: operações de escrita não são permitidas em tabelas externas !!!