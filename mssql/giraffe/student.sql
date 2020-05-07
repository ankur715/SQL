---------- Database ----------
/*
- collection of related information
- DBMS helps create and maintain databases
- handle security, backups
- Create Read Update Delete (CRUD) operations
- relational databases (SQL)
- query specific information
*/

CREATE DATABASE giraffe;

USE giraffe;

/*
common datatypes
- int: whole numbers
- decimal(m,n): m digits, n after decimal
- varchar(l): string of text of length l
- blob: binary large object, stored large data
- date: 'yyyy-mm-dd'
- timestamp: 'yyyy-mm-dd hh:mm:ss' 
*/

CREATE TABLE student (
	student_id INT PRIMARY KEY,
	name VARCHAR(20),
	major VARCHAR(20),
	--PRIMARY KEY(student_id)
);

EXEC sp_columns student;

DROP TABLE student;

ALTER TABLE student 
ADD gpa DECIMAL(3,2);

ALTER TABLE student
DROP COLUMN gpa;

INSERT INTO student VALUES(1, 'Jack', 'Biology');

SELECT * FROM student;

INSERT INTO student VALUES(2, 'Kate', 'Biology');
SELECT * FROM student;

-- primary key
INSERT INTO student VALUES(2, 'Jill', 'Math');

INSERT INTO student VALUES(3, 'Jill', 'Math');

-- if no major value
INSERT INTO student(student_id, name) VALUES(4, 'Bob');
SELECT * FROM student;

INSERT INTO student VALUES(5, 'Ankur', 'Data Science');
SELECT * FROM student;

-- DROP TABLE student;
CREATE TABLE student (
	student_id INT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	major VARCHAR(20) UNIQUE,  --rejected if not unique
	--PRIMARY KEY(student_id)
);

INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES(2, 'Kate', 'Biology');
INSERT INTO student VALUES(3, NULL, 'Math');
INSERT INTO student(student_id, name) VALUES(4, 'Bob');
INSERT INTO student VALUES(5, 'Ankur', 'Data Science');
SELECT * FROM student;

DROP TABLE student;
CREATE TABLE student (
	student_id INT PRIMARY KEY,
	name VARCHAR(20),
	major VARCHAR(20) DEFAULT 'undecided',	--, 
);

INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES(2, 'Kate', 'Biology');
INSERT INTO student VALUES(3, NULL, 'Math');
INSERT INTO student(student_id, name) VALUES(4, 'Bob');
INSERT INTO student VALUES(5, 'Ankur', 'Data Science');
SELECT * FROM student;

DROP TABLE student;
CREATE TABLE student (
	student_id INT IDENTITY(1,1) PRIMARY KEY,  --start at 1, increment by 1
	name VARCHAR(20),
	major VARCHAR(20) DEFAULT 'undecided',	--, 
);

INSERT INTO student(name, major) VALUES('Jack', 'Biology');
INSERT INTO student(name, major) VALUES('Kate', 'Chemistry');
SELECT * FROM student;

INSERT INTO student VALUES(NULL, 'Math');
INSERT INTO student VALUES('Bob', 'Math');
INSERT INTO student VALUES('Ankur', 'Data Science');
SELECT * FROM student;

-- update with condition
UPDATE student
SET major = 'Bio'
WHERE major = 'Biology';
SELECT * FROM student;

UPDATE student
SET name = 'Jill'
WHERE student_id = 3;
SELECT * FROM student;

UPDATE student
SET name = 'Tom', major='undecided'
WHERE student_id = 3;

-- to all rows
UPDATE student
SET name = 'Tom', major='undecided';
SELECT * FROM student;

-- delete all rows
DELETE FROM student;

DELETE FROM student
WHERE student_id = 1;
SELECT * FROM student;

DELETE FROM student
WHERE name = 'Tom' AND major = 'undecided';
SELECT * FROM student;

SELECT name
FROM student;

SELECT name, major
FROM student;

-- prepend with table name
SELECT student.name, student.major
FROM student;

SELECT student.name, student.major
FROM student
ORDER BY name;

SELECT student.name, student.major
FROM student
ORDER BY name DESC;  --default is alphabetical

SELECT student.name, student.major
FROM student
ORDER BY student_id ASC; 

-- major first, then student_id
SELECT *
FROM student
ORDER BY major, student_id; 

SELECT TOP 2 *
FROM student;

INSERT INTO student(name, major) VALUES('Bob', 'Geography');
INSERT INTO student VALUES('Ankur', 'Data Science');

SELECT TOP 20 PERCENT *
FROM student s
ORDER BY major, student_id;

SELECT name, major
FROM student
WHERE major = 'Chemistry' OR major = 'Data Science';
-- <, >, <=, >=, =, <>, AND, OR

SELECT name, major
FROM student
WHERE name IN ('Kate', 'Bob');

SELECT * FROM student;

SELECT DISTINCT name FROM student;

SELECT name, major
FROM student
WHERE name IN ('Kate', 'Bob') AND student_id > 3;

