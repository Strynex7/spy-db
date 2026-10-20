CREATE DATABASE college_db;
USE college_db;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL UNIQUE
) AUTO_INCREMENT = 1;

CREATE TABLE Student (
    stud_id INT PRIMARY KEY AUTO_INCREMENT,
    stud_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE,
    age INT CHECK (age >= 18),
    city VARCHAR(30) DEFAULT 'Pune',
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
) AUTO_INCREMENT = 101;

CREATE VIEW stud AS SELECT * FROM Student;

DESC Department;
DESC Student;

INSERT INTO Department (dept_name) VALUES
('Computer'),
('AIDS'),
('AIML'),
('ENTC');

INSERT INTO Student (stud_name, email, age, city, dept_id) VALUES
('Kunal', 'kunal@gmail.com', 20, 'Pune', 1),
('Vedant', 'vedant@gmail.com', 22, 'Mumbai', 2),
('Priya', 'priya@gmail.com', 21, 'Pune', 2),
('Amit', 'amit@gmail.com', 19, 'Nashik', 1),
('Sneha', 'sneha@gmail.com', 22, 'Pune', 3);

SELECT * FROM Student;

SELECT * FROM Department;

SELECT * FROM stud;

SELECT * FROM Student WHERE age > 20;

SELECT * FROM Student ORDER BY stud_name;

SELECT stud_name, city FROM Student WHERE city = 'Pune';

SELECT stud_name FROM Student WHERE stud_name LIKE 'P%';

SELECT COUNT(*) FROM Student;

SELECT AVG(age) FROM Student;

SELECT MAX(age) FROM Student;

SELECT dept_id, COUNT(*) FROM Student GROUP BY dept_id;

SELECT Student.stud_name, Department.dept_name
FROM Student
JOIN Department ON Student.dept_id = Department.dept_id;

UPDATE Student SET age = 21 WHERE stud_name = 'Kunal';

UPDATE Student SET dept_id = 4 WHERE stud_name = 'Sneha';

DELETE FROM Student WHERE stud_name = 'Amit';

SELECT * FROM Student;
