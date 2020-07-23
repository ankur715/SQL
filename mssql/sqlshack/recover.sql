-- Recover data deleted from a SQL Delete statement

-- suppose you require to recover the deleted data from the existing backups. 
-- We will create a new database from the full backup. 
-- We need to restore a backup in NORECOVERY mode so that we can apply further transaction log backup on it.

USE [master];
RESTORE DATABASE [SQLShackDemo_restore] FROM DISK = N'C:\temp\SQLShackDemo.bak' WITH FILE = 1,
MOVE N'SQLShackDemo' TO N'C:\sqlshack\Demo\SQLShackDemo.mdf', 
MOVE N'SQLShackDemo_log' TO N'C:\sqlshack\Demo\SQLShackDemo_log.ldf',
NORECOVERY, NOUNLOAD, STATS = 5;
GO

-- LSN values in fn_dblog are in the hexadecimal format. 
-- Restore log command requires LSN in a decimal format. 
-- We can use the following query to convert it into the decimal format. 
-- Here, specify the LSN in the @LSN parameter.
DECLARE @LSN VARCHAR(22), @LSN1 VARCHAR(11), @LSN2 VARCHAR(10), @LSN3 VARCHAR(5);
SET @LSN = '00000026:00000230:0001';
SET @LSN1 = LEFT(@LSN, 8);
SET @LSN2 = SUBSTRING(@LSN, 10, 8);
SET @LSN3 = RIGHT(@LSN, 4);
SET @LSN1 = CAST(CONVERT(VARBINARY, '0x' + RIGHT(REPLICATE('0', 8) + @LSN1, 8), 1) AS INT);
SET @LSN2 = CAST(CONVERT(VARBINARY, '0x' + RIGHT(REPLICATE('0', 8) + @LSN2, 8), 1) AS INT);
SET @LSN3 = CAST(CONVERT(VARBINARY, '0x' + RIGHT(REPLICATE('0', 8) + @LSN3, 8), 1) AS INT);
SELECT CAST(@LSN1 AS VARCHAR(8)) + CAST(RIGHT(REPLICATE('0', 10) + @LSN2, 10) AS VARCHAR(10)) + CAST(RIGHT(REPLICATE('0', 5) + @LSN3, 5) AS VARCHAR(5));


-- Now, run the restore log query using the STOPBEFORMARK parameter. This query stops the processing of database restores before the specified LSN.
Restore log  [SQLShackDemo_restore] FROM DISK = N'C:\temp\SQLShackDemo_log.trn'
with STOPBEFOREMARK ='lsn:38000000056000001'


-- Recover data deleted from a SQL Truncate statement
USE [master];
RESTORE DATABASE [SQLShackDemo_restore_1] FROM DISK = N'C:\TEMP\SQLShackdemo.bak' WITH FILE = 1,
MOVE N'SQLShackDemo' TO N'C:\sqlshack\Demo\SQLShackDemo.mdf', 
MOVE N'SQLShackDemo_log' TO N'C:\sqlshack\Demo\SQLShackDemo_log.ldf',
NORECOVERY, NOUNLOAD, STATS = 5;
GO


Restore log  [SQLShackDemo_restore_1] FROM DISK = N'C:\temp\SQLShackdemo_log.trn'
with STOPBEFOREMARK ='lsn:38000000061600001'



