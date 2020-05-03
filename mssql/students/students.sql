CREATE DATABASE Students;

USE Students;
-- active database

CREATE TABLE StudentsInfo
(
StudentID int,
StudentName varchar(8000),
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000),
City varchar(8000),
Country varchar(8000)
);

DROP TABLE StudentsInfo;
-- delete table

DROP DATABASE Students;
-- can't drop active database

CREATE DATABASE Trial;
USE Trial;
CREATE TABLE Trial
(
FirstName varchar(8000),
LastName varchar(8000)
);

ALTER TABLE StudentsInfo ADD BloodGroup varchar(8000);
-- add column

SELECT * FROM StudentsInfo;
-- see table

ALTER TABLE StudentsInfo DROP COLUMN BloodGroup;
-- drop column

ALTER TABLE StudentsInfo ADD DOB DATE;
-- add DOB column

ALTER TABLE StudentsInfo ALTER COLUMN DOB DATETIME;
-- change datatype

INSERT INTO StudentsInfo VALUES ('07', 'Ankur', 'Patel', '2514476000', 'Henry Street', 'Manhattan', 'US');
-- insert row values

SELECT * FROM StudentsInfo;

TRUNCATE TABLE StudentsInfo;
-- deletes the data inside a table

SP_RENAME 'StudentsInfo', 'InfoStudents';
-- rename database

SELECT * FROM StudentsInfo;
SELECT * FROM InfoStudents; 

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

INSERT INTO StudentsInfo2 VALUES ('07', NULL, 'Patel', '2514476000', 'Henry Street', 'Toronto', 'Canada');
INSERT INTO StudentsInfo2 VALUES ('07', 'Ankur', 'Patel', '2514476000', 'Henry Street', 'Toronto', 'Canada');

ALTER TABLE StudentsInfo2 ALTER COLUMN PhoneNumber int NOT NULL;
-- not null phonenumber column

DROP TABLE StudentsInfo2;

CREATE TABLE StudentsInfo2
(
StudentID int UNIQUE NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000)
PRIMARY KEY (StudentID)
);
-- unique ID

DROP TABLE StudentsInfo2;

CREATE TABLE StudentsInfo2
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000)
CONSTRAINT UC_StudentsInfo UNIQUE(StudentID, PhoneNumber)
);
-- multiple unique columns

INSERT INTO StudentsInfo2 VALUES ('09', 'Bob', 'Smith', '2514476000', 'Cal Street', 'Manhattan', 'US');
SELECT * FROM StudentsInfo2;

ALTER TABLE StudentsInfo2 ADD UNIQUE(StudentID);
-- add unique constraint

ALTER TABLE StudentsInfo2 
DROP CONSTRAINT UC_StudentsInfo;

DROP TABLE StudentsInfo2;

CREATE TABLE StudentsInfo2
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000) CHECK (country = 'US')
);

INSERT INTO StudentsInfo2 VALUES ('09', 'Bob', 'Smith', '2514476000', 'Cal Street', 'Manhattan', 'India');
-- check constraint country='US'

INSERT INTO StudentsInfo2 
VALUES 
--	('07', 'Ankur', 'Patel', '2514476000', 'Henry Street', 'Toronto', 'Canada'),
	('09', 'Bob', 'Smith', '2514476000', 'Cal Street', 'Manhattan', 'US')
ALTER TABLE StudentsInfo2 
ADD CHECK (Country = 'US');
-- add check constraint

SELECT * FROM StudentsInfo2;

ALTER TABLE StudentsInfo2 
ADD CONSTRAINT CHECKCONSTRAINTNAME CHECK (Country = 'US');
-- add check constraint

ALTER TABLE StudentsInfo2 
DROP CONSTRAINT CHECKCONSTRAINTNAME;
-- drop check constraint

DROP TABLE StudentsInfo2;

CREATE TABLE StudentsInfo2
(
StudentID int NOT NULL,
StudentName varchar(8000) NOT NULL,
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000) NOT NULL,
City varchar(8000),
Country varchar(8000) DEFAULT 'US'
);
-- unassigned country values US

ALTER TABLE StudentsInfo2
ADD CONSTRAINT default_city
DEFAULT 'Brooklyn' FOR City;
-- default contraint city
-- can be deleted in object explorer

-- table of database
CREATE INDEX index_studentname
ON StudentsInfo2 (StudentName);

DROP INDEX StudentsInfo2.index_studentname;