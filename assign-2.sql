CREATE DATABASE IF NOT EXISTS exam_db;
USE exam_db;

CREATE TABLE student (
    stud_id INT PRIMARY KEY,
    stud_name VARCHAR(50),
    email VARCHAR(50),
    age INT,
    city VARCHAR(30)
);

INSERT INTO student VALUES
(1, 'Kunal', 'kunal@gmail.com', 20, 'Pune'),
(2, 'Vedant', 'vedant@gmail.com', 22, 'Mumbai'),
(3, 'Priya', 'priya@gmail.com', 21, 'Pune'),
(4, 'Amit', 'amit@gmail.com', 19, 'Nashik'),
(5, 'Sneha', 'sneha@gmail.com', 22, 'Pune');

SELECT * FROM student;




SELECT * FROM student
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/student_export.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT * FROM student
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/student_export.txt'
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n';

CREATE TABLE student_copy LIKE student;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/student_export.csv'
INTO TABLE student_copy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';




SELECT * FROM student_copy;

TRUNCATE TABLE student_copy;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/student_export.txt'
INTO TABLE student_copy
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n';

SELECT * FROM student_copy;








TRUNCATE TABLE student_copy;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/student_xlsx.csv'
INTO TABLE student_copy
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT * FROM student_copy;
