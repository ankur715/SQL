USE SSIS
SELECT table_name, column_name FROM INFORMATION_SCHEMA.COLUMNS

CREATE TABLE [dbo].[ChurnT](
	[State] [varchar](1) NULL,               -- altered later (in SSIS)
	[Account Length] [varchar](50) NULL,
	[Area Code] [nvarchar](50) NULL,         -- transformed later (in SSIS)
	[Phone] [varchar](50) NULL,
	[Int'l Plan] [varchar](50) NULL,
	[VMail Plan] [varchar](50) NULL,
	[VMail Message] [varchar](50) NULL,
	[Day Mins] [varchar](50) NULL,
	[Day Calls] [varchar](50) NULL,
	[Day Charge] [varchar](50) NULL,
	[Evening Mins] [varchar](50) NULL,
	[Evening Calls] [varchar](50) NULL,
	[Evening Charge] [varchar](50) NULL,
	[Night Mins] [varchar](50) NULL,
	[Night Calls] [varchar](50) NULL,
	[Night Charge] [varchar](50) NULL,
	[Intl Mins] [varchar](50) NULL,
	[Intl Calls] [varchar](50) NULL,
	[Intl Charge] [varchar](50) NULL,
	[CustServ Calls] [varchar](50) NULL,
	[Churn?] [varchar](50) NULL
)

SELECT * FROM [dbo].[ChurnT]

SELECT * FROM INFORMATION_SCHEMA.COLUMNS

-- State column created with VARCHAR(1)
ALTER TABLE [dbo].[ChurnT]
ALTER COLUMN State VARCHAR(50)

-- empty Churn table before reloading  
-- 1. can run query here, then re-execute on SSIS
-- 2. or copy this query in SSIS control flow
DELETE FROM ChurnT

SELECT COUNT(*) FROM [dbo].[ChurnT]
SELECT DISTINCT * FROM [dbo].[ChurnT]


