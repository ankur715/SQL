USE Students;

CREATE TABLE StudentsInfo2
(
StudentID int,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000)
);
SP_RENAME 'StudentsInfo2', 'InfoStudents';

-- list of tables
SELECT * FROM SYS.TABLES;

-- list of tables and views
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- without USE
SELECT
  *
FROM
  Students.INFORMATION_SCHEMA.TABLES;

SELECT * FROM InfoStudents;
INSERT INTO InfoStudents VALUES ('07', 'Ankur', 'Patel', '2514476000', 'Henry Street', 'Toronto', 'Canada');
INSERT INTO InfoStudents VALUES ('06', 'Bob', 'Clinton', '123241234', 'Columbia Street', 'Calgary', 'Canada');
INSERT INTO InfoStudents VALUES ('05', 'Will', 'Trey', '4324232423', 'Airport', 'Montreal', 'Canada');
INSERT INTO InfoStudents VALUES ('04', 'Jamie', 'Smith', '3242342444', 'Broadway', 'Manhattan', 'US');
INSERT INTO InfoStudents VALUES ('03', 'James', 'Mark', '2344424324', '42nd Street', 'Brooklyn', 'US');
-- insert row values

SP_RENAME 'InfoStudents', 'StudentsInfo2';
SELECT * FROM StudentsInfo2;

UPDATE StudentsInfo2 SET StudentName = 'Alex', City = 'Brooklyn'
WHERE StudentID = 03; 
-- change/update namecity of a studentid
SELECT * FROM StudentsInfo2;

DELETE FROM StudentsInfo2
WHERE StudentName = 'Alex';
-- delete records
SELECT * FROM StudentsInfo2;

CREATE TABLE SampleSourceTable(StudentID int, StudentName varchar(8000), Grade int);
CREATE TABLE SampleTargetTable(StudentID int, StudentName varchar(8000), Grade int);

INSERT INTO SampleSourceTable VALUES ('7', 'Ankur', '100');	
INSERT INTO SampleSourceTable VALUES ('6', 'Bob', '80');
INSERT INTO SampleSourceTable VALUES ('5', 'Will', '60');

INSERT INTO SampleTargetTable VALUES ('7', 'Ankur', '100');
INSERT INTO SampleTargetTable VALUES ('6', 'Bob', '75');
INSERT INTO SampleTargetTable VALUES ('5', 'Sam', '55');

SELECT * FROM SampleSourceTable;

SELECT * FROM SampleTargetTable;

MERGE SampleTargetTable TARGET USING SampleSourceTable SOURCE ON (TARGET.StudentID = SOURCE.StudentID)
WHEN MATCHED AND TARGET.StudentName <> SOURCE.StudentName OR TARGET.Grade <> SOURCE.Grade
THEN
UPDATE SET TARGET.StudentName = SOURCE.StudentName, TARGET.Grade = SOURCE.Grade
WHEN NOT MATCHED BY TARGET THEN
INSERT (StudentID, StudentName, Grade) VALUES (SOURCE.StudentID, SOURCE.StudentName, SOURCE.Grade)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE;
-- merge tables on studentid 
-- studentid matched and studentname or grade are same
-- then set target name,grade as source name,grade
-- when not matched by target, then insert
-- when not matched by source, then delete

SELECT * FROM SampleSourceTable;

SELECT * FROM SampleTargetTable;

-- DROP TABLE SampleSourceTable;
-- DROP TABLE SampleTargetTable;

SELECT StudentID, StudentName FROM InfoStudents;

SELECT TOP 3 * FROM InfoStudents;
SELECT * FROM InfoStudents;

SELECT DISTINCT City FROM InfoStudents;

SELECT * FROM InfoStudents ORDER BY ParentName DESC;

SELECT * FROM InfoStudents ORDER BY ParentName, StudentName;
-- parentname ordered first in asc

SELECT * FROM InfoStudents ORDER BY ParentName ASC, StudentName DESC;

-- number of students from each city
SELECT COUNT(StudentID), City FROM InfoStudents GROUP BY City;

SELECT StudentID, StudentName, COUNT(City) FROM InfoStudents 
GROUP BY GROUPING SETS ((StudentID, StudentName, City), (StudentID), (StudentName), (City));

-- having clause
SELECT * FROM InfoStudents;
SELECT COUNT(StudentID), City FROM InfoStudents GROUP BY City HAVING COUNT(StudentID) = 1
ORDER BY COUNT(StudentID) DESC;

-- backup table
SELECT * INTO StudentsBackup FROM InfoStudents;

SELECT * INTO MontrealStudents FROM InfoStudents WHERE City = 'Montreal';
SELECT * FROM MontrealStudents;

SELECT StudentID, COUNT(City) FROM InfoStudents GROUP BY CUBE(StudentID) ORDER BY StudentID;
-- adds all the “cross-tabulations” rows
SELECT StudentID, COUNT(City) FROM InfoStudents GROUP BY ROLLUP(StudentID);

CREATE TABLE OffsetGrades (Grade int);
INSERT INTO OffsetGrades VALUES ('65');
INSERT INTO OffsetGrades VALUES ('64');
INSERT INTO OffsetGrades VALUES ('63');
INSERT INTO OffsetGrades VALUES ('62');
INSERT INTO OffsetGrades VALUES ('61');
INSERT INTO OffsetGrades VALUES ('71');

SELECT * FROM OffsetGrades ORDER BY Grade OFFSET 2 ROWS;

SELECT * FROM OffsetGrades ORDER BY Grade OFFSET 2 ROWS FETCH NEXT 2 ROWS ONLY;
-- fetch/return top 2 records from table

SELECT * FROM OffsetGrades;

-- pivot used to rate rows to cols, aggregations on remaining cols
-- select nonpivoted col, then first pivoted col till last pivoted col
-- from select query of pivot which has aggregate data
CREATE TABLE SuppierTable
(
SuppierID int NOT NULL,
DaysofManufacture int,
Cost int,
CustomerID int,
PurchaseID varchar(4000)
);

INSERT INTO SuppierTable VALUES ('1', '12', '1230', '11', 'P1');
INSERT INTO SuppierTable VALUES ('2', '21', '1543', '22', 'P2');
INSERT INTO SuppierTable VALUES ('3', '32', '2345', '11', 'P3');
INSERT INTO SuppierTable VALUES ('4', '14', '8437', '22', 'P1');
INSERT INTO SuppierTable VALUES ('5', '42', '3453', '44', 'P3');
INSERT INTO SuppierTable VALUES ('6', '31', '2133', '33', 'P1');
INSERT INTO SuppierTable VALUES ('7', '41', '2134', '11', 'P2');
INSERT INTO SuppierTable VALUES ('8', '54', '4665', '22', 'P2');
INSERT INTO SuppierTable VALUES ('9', '62', '5326', '33', 'P1');
INSERT INTO SuppierTable VALUES ('10', '36', '1111', '11', 'P3');
INSERT INTO SuppierTable VALUES ('1', '12', '1230', '33', 'P1');

SELECT CustomerID, AVG(Cost) as AverageCostOfCustomer FROM SuppierTable GROUP BY CustomerID;

-- pivot table of 1 row 4 cols
SELECT 'AverageCostOfCustomer' AS Cost_According_To_Customers, [11],[22],[33],[44]
FROM (
SELECT CustomerID, Cost FROM SuppierTable) AS SourceTable
PIVOT
(
AVG(Cost) FOR CustomerID IN ([11],[22],[33],[44])) AS PivotTable;

CREATE TABLE SampleTable (SuppierID int, AAA int, BBB int, CCC int)
GO 
INSERT INTO SampleTable VALUES(1,3,5,7);
INSERT INTO SampleTable VALUES(2,3,6,7);
INSERT INTO SampleTable VALUES(3,4,5,5);
GO
SELECT * FROM SampleTable; 

-- unpivot
SELECT SuppierID, Customers, Products
FROM 
(SELECT SuppierID, AAA, BBB, CCC FROM SampleTable) p
UNPIVOT
(Products FOR Customers IN (AAA, BBB, CCC)) AS Example;
GO

-- operators 
-- handle manipulate retrieve
SELECT 40+60;

SELECT * FROM OffsetGrades WHERE Grade >= '65';

-- compount operators
DECLARE @var1 int = 30;
SET @var1 /= 3;
SELECT @var1 AS Example;
-- quotient 10

DECLARE @a int = 13;
SET @a %= 2;
SELECT @a;
-- remainder 1

-- logical operator
SELECT * FROM OffsetGrades WHERE Grade BETWEEN '60' AND '65';

SELECT * FROM OffsetGrades WHERE Grade > '64' OR Grade = '71';

SELECT * FROM InfoStudents; 

SELECT * FROM InfoStudents WHERE StudentName LIKE 'J%'; 
-- name starts with J

SELECT * FROM InfoStudents WHERE City LIKE 'M________%'; 
-- city starts with M and 8 more letters

SELECT * FROM InfoStudents WHERE City LIKE 'M%L'; 
-- starts with M & ends with L

-- scope resolution operator :: to access getroot member of hierachyid type
DECLARE @exid hierarchyid;
SELECT @exid = hierarchyid::GetRoot();
PRINT @exid.ToString();  --convert to string

-- string concatenation operator
SELECT (StudentName+', '+ParentName) AS Name FROM InfoStudents;

-- aggregate
SELECT AVG(Grade) FROM OffsetGrades;

-- set operator
CREATE TABLE InfoStudentsDetails
(
StudentID int,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000)
);
INSERT INTO InfoStudentsDetails VALUES ('17', 'AnkurD', 'PatelD', '25144760000', 'Henry StreetD', 'TorontoD', 'CanadaD');
INSERT INTO InfoStudentsDetails VALUES ('16', 'BobD', 'ClintonD', '1232412344', 'Columbia StreetD', 'CalgaryD', 'CanadaD');
INSERT INTO InfoStudentsDetails VALUES ('15', 'WillD', 'TreyD', '43242324233', 'AirportD', 'MontrealD', 'CanadaD');
INSERT INTO InfoStudentsDetails VALUES ('07', 'Ankur', 'Patel', '2514476000', 'Henry Street', 'Toronto', 'Canada');

SELECT * FROM InfoStudentsDetails;

-- union of tables
SELECT * FROM InfoStudents
UNION
SELECT * FROM InfoStudentsDetails;

-- intersect
SELECT * FROM InfoStudents
INTERSECT
SELECT * FROM InfoStudentsDetails;

-- except
SELECT * FROM InfoStudents
EXCEPT
SELECT * FROM InfoStudentsDetails;

SELECT * FROM InfoStudentsDetails
EXCEPT
SELECT * FROM InfoStudents;

-- nested queries: subquery first, then outer query
SELECT StudentName, ParentName
FROM InfoStudents
WHERE AddressofStudent IN (SELECT AddressofStudent FROM StudentsBackup WHERE Country = 'US');

CREATE TABLE Subjects(SubjectID int, StudentID int, SubjectName varchar(8000));

INSERT INTO Subjects VALUES ('1', '10', 'Math');
INSERT INTO Subjects VALUES ('2', '11', 'Computer');
INSERT INTO Subjects VALUES ('3', '12', 'Science');
INSERT INTO Subjects VALUES ('4', '7', 'Data');

--- inner join
SELECT Subjects.SubjectID, InfoStudents.StudentID
FROM Subjects
INNER JOIN
InfoStudents ON
InfoStudents.StudentID = Subjects.StudentID;

-- left join 
SELECT Subjects.SubjectID, InfoStudents.StudentName
FROM InfoStudents
LEFT JOIN
Subjects ON
InfoStudents.StudentID = Subjects.StudentID
ORDER BY InfoStudents.StudentName;
-- inner and everything from left

-- right join 
SELECT Subjects.SubjectID, InfoStudents.StudentName
FROM InfoStudents
RIGHT JOIN
Subjects ON
InfoStudents.StudentID = Subjects.StudentID
ORDER BY InfoStudents.StudentName;

-- outer join 
SELECT Subjects.SubjectID, InfoStudents.StudentName
FROM InfoStudents
FULL OUTER JOIN
Subjects ON
InfoStudents.StudentID = Subjects.StudentID
ORDER BY InfoStudents.StudentName;

-- stored procedures
-- group of sql statements and logic for a task
CREATE PROCEDURE Students_City @SCity varchar(8000)  --parameter name SCity
AS 
SELECT * FROM InfoStudents
WHERE City = @SCity
GO
SELECT * FROM InfoStudents
EXEC Students_City @SCity = 'Manhattan'

-- DCL(Data Control Language) commands
CREATE LOGIN SAMPLE WITH PASSWORD = 'ankur';

CREATE USER Ankur FOR LOGIN SAMPLE;

-- grant privileges to user
GRANT SELECT ON InfoStudents TO Ankur;

-- revoke granted privileges
REVOKE SELECT ON InfoStudents TO Ankur;

--TCL(Transaction Control Language) commands
CREATE TABLE TCLSample (StudentID int, StudentName varchar(8000), Grade int);
INSERT INTO TCLSample VALUES (1, 'Rob', 23);
INSERT INTO TCLSample VALUES (2, 'Steve', 33);
INSERT INTO TCLSample VALUES (3, 'Trey', 43);
INSERT INTO TCLSample VALUES (4, 'Nat', 53);

-- try catch block for adding transcations
BEGIN TRY
BEGIN TRANSACTION
INSERT INTO TCLSample VALUES (5, 'Li', 63);
UPDATE TCLSample SET StudentName = 'Lee' WHERE StudentID = '5';
UPDATE TCLSample SET Grade = '99';  --99/0
COMMIT TRANSACTION
PRINT 'Transaction Completed'
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT 'Transaction Unsuccessful and rolledback'
END CATCH

SELECT * FROM TCLSample;

-- exceptional handling
-- throw clause
THROW 51000, 'Record does not exist.', 1;

BEGIN TRY
SELECT PhoneNumber+StudentName FROM InfoStudents;
END TRY
BEGIN CATCH
PRINT 'Not possible'
END CATCH
-- cannot add these columns

BEGIN TRY
SELECT PhoneNumber, StudentName FROM InfoStudents;
END TRY
BEGIN CATCH
PRINT 'Not possible'
END CATCH

