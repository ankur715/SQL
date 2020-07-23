-- retrieve database backup history from the msdb system database
USE SQLShackDemo;
SELECT bs.database_name AS DatabaseName,
    CASE bs.type
        WHEN 'D'
        THEN 'Full'
        WHEN 'I'
        THEN 'Differential'
        WHEN 'L'
        THEN 'Transaction Log'
    END AS BackupType, 
    CAST(bs.first_lsn AS VARCHAR(50)) AS FirstLSN, 
    CAST(bs.last_lsn AS VARCHAR(50)) AS LastLSN, 
    bmf.physical_device_name AS PhysicalDeviceName, 
    CAST(CAST(bs.backup_size / 1000000 AS INT) AS VARCHAR(14)) + ' ' + 'MB' AS BackupSize, 
    bs.recovery_model AS RecoveryModel
FROM msdb.dbo.backupset AS bs
  INNER JOIN msdb.dbo.backupmediafamily AS bmf ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = 'SQLShackDemo'
ORDER BY backup_start_date DESC, 
      backup_finish_date;

-- It gives first and last log sequence number (LSN) details as well.

-- Insert ten records in both tables.

SELECT * FROM DeletemyData;
SELECT * FROM TruncatemyData;

DECLARE @id INT;
SET @ID = 10;
WHILE(@ID > 0)
    BEGIN
        INSERT INTO DeletemyData([Name])
    VALUES('Delete Data' + ' ' + CAST((@ID) AS VARCHAR));
        SET @ID = @ID - 1;
    END;
SELECT * FROM DeletemyData;
 
DECLARE @id INT;
SET @ID = 10;
WHILE(@ID > 0)
    BEGIN
        INSERT INTO TruncatemyData([Name])
    VALUES('Truncate data' + ' ' + CAST((@ID) AS VARCHAR));
        SET @ID = @ID - 1;
    END;
SELECT * FROM TruncatemyData;




