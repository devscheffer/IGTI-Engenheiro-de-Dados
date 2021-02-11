/*######## NO SERVIDOR PRINCIPAL */

--Listar versão e edição
SELECT @@VERSION AS SQL_Version, SERVERPROPERTY('ProductVersion') AS version,
SERVERPROPERTY ('productlevel') AS ServicePack, SERVERPROPERTY('EDITION') AS SQLEdition


--Alterar o Recovery Model do banco principal para FULL
USE [master]
GO
ALTER DATABASE [AdventureWorks2019] SET RECOVERY FULL WITH NO_WAIT
GO

--Gerar backup do banco principal
BACKUP DATABASE [AdventureWorks2019] TO DISK = 'C:\Temp\AdventureWorks2019.bak' 
WITH NOFORMAT, NOINIT, NAME = N' Backup_AdventureWorks-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION
GO


/*######## NO SERVIDOR SECUNDÁRIO (MIRROR) */

--Listar versão e edição
SELECT @@VERSION AS SQL_Version, SERVERPROPERTY('ProductVersion') AS version,
SERVERPROPERTY ('productlevel') AS ServicePack, SERVERPROPERTY('EDITION') AS SQLEdition

--Restaurar Banco (deixando no NORECOVERY) 
USE [master]
GO

RESTORE DATABASE [AdventureWorks2019] 
FROM  DISK = N'C:\Temp\AdventureWorks2019.bak' WITH  FILE = 1,  
MOVE N'AdventureWorks2019' TO N'C:\Temp\AdventureWorks2019_Data.mdf',  
MOVE N'AdventureWorks2019_Log' TO N'C:\Temp\AdventureWorks2019_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5
GO


/*######## NO SERVIDOR PRINCIPAL */

--Fazer backup do log

USE master
GO
BACKUP LOG [AdventureWorks2019] TO  DISK = N'C:\Temp\AdventureWorks2019_LOG.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks-Full Database Backup', SKIP, 
NOREWIND, NOUNLOAD,  STATS = 10
GO


/*######## NO SERVIDOR SECUNDÁRIO (MIRROR) */

--Restaurar backup de log

RESTORE LOG [AdventureWorks2019] FROM  DISK = N'C:\Temp\AdventureWorks2019_LOG.bak' WITH  FILE = 1,  
MOVE N'AdventureWorks2019' TO N'C:\Temp\AdventureWorks2019_Data.mdf',  
MOVE N'AdventureWorks2019_Log' TO N'C:\Temp\AdventureWorks2019_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5


/*######## NO SERVIDOR PRINCIPAL */

--1)Criar Endpoint e configurar as permissões para as contas de serviço
--2)Configurar Principal e Mirror (informando o endpoint)
--3)Escolher o tipo de consistência (Operation Mode)
--4)Iniciar o Mirror


--Verificar status do mirror (no primário e no secundário)
select d.name, m.mirroring_state_desc, m.mirroring_role, m.mirroring_role_desc,
m.mirroring_partner_name, m.mirroring_partner_instance
from master..sysdatabases d inner join sys.database_mirroring m on (d.dbid=m.database_id) 
where m.mirroring_guid is not null;
go


/*######## NO SERVIDOR SECUNDÁRIO */

--Tentar usar o banco

USE AdventureWorks2019 
GO

--##### Parar o servidor primário

--Verificar o status NO mirror
select d.name, m.mirroring_state_desc, m.mirroring_role, m.mirroring_role_desc,
m.mirroring_partner_name, m.mirroring_partner_instance
from master..sysdatabases d inner join sys.database_mirroring m on (d.dbid=m.database_id) 
where m.mirroring_guid is not null;

--##### Subir servidor primário

--Verificar o status do mirror
select d.name, m.mirroring_state_desc, m.mirroring_role, m.mirroring_role_desc,
m.mirroring_partner_name, m.mirroring_partner_instance
from master..sysdatabases d inner join sys.database_mirroring m on (d.dbid=m.database_id) 
where m.mirroring_guid is not null;



/*######## NO SERVIDOR PRINCIPAL */

--Criar tabela a ser replicada
USE AdventureWorks2019
GO
create table teste_mirror (codigo int)
go
insert into teste_mirror
values (1)
go
insert into teste_mirror
values (2)
go

select * 
from teste_mirror
go


--Alterar o Operation Mode para SÍNCRONO (garantir a consistência máxima dos dados)
USE [master]
GO
ALTER DATABASE [AdventureWorks2019] SET SAFETY FULL
GO

-- Fazer o failover manualmente
ALTER DATABASE AdventureWorks2019 SET PARTNER FAILOVER
GO


--Usar a tabela no Principal atual (ex-mirror)
USE AdventureWorks2019
GO
SELECT *
FROM teste_mirror
GO


-- Fazer o failover manualmente de volta
USE master
GO
ALTER DATABASE AdventureWorks2019 SET PARTNER FAILOVER
GO


--Snapshot para ler dados no mirror
CREATE DATABASE AdventureWorks2019_SNAP ON  
( NAME = AdventureWorks2019, FILENAME =   
'C:\Temp\AdventureWorks2019_SNAP_data.ss' )  
AS SNAPSHOT OF AdventureWorks2019;  
GO 

--Usar tabela no Snapshot
USE AdventureWorks2019_SNAP
GO

SELECT * FROM dbo.teste_mirror
GO

--Apagar a tabela no principal
USE AdventureWorks2019
GO
DROP TABLE teste_mirror
GO

SELECT * FROM AdventureWorks2019.dbo.teste_mirror
GO

--No Snapshot
SELECT * FROM AdventureWorks2019_SNAP.dbo.teste_mirror
GO

--Atualizar Snapshot
DROP DATABASE AdventureWorks2019_SNAP
GO
CREATE DATABASE AdventureWorks2019_SNAP ON  
( NAME = AdventureWorks2019, FILENAME =   
'C:\Temp\AdventureWorks2019_SNAP_data.ss' )  
AS SNAPSHOT OF AdventureWorks2019;  
GO 

--No Snapshot
SELECT * FROM AdventureWorks2019_SNAP.dbo.teste_mirror
GO
