-- Create a database
CREATE DATABASE SQLShackDemo;
GO
USE SQLShackDemo;
GO

-- Create SQL tables for delete statement and truncate statement
CREATE TABLE DeletemyData
(id     INT IDENTITY(1, 1), 
 [Name] VARCHAR(40)
);
GO
CREATE TABLE TruncatemyData
(id     INT IDENTITY(1, 1), 
 [Name] VARCHAR(40)
);
GO

BACKUP DATABASE SQLShackDemo TO DISK='C:\temp\SQLShackDemo.bak'




