CREATE DATABASE EmployeeDB;
USE EmployeeDB;

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    age INT,
    salary DECIMAL(10,2)
);

INSERT INTO Employee VALUES
(1, 'Amit', 22, 25000),
(2, 'Rahul', 25, 30000);

DELIMITER //

CREATE TRIGGER Validate_Employee
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than 0';
    END IF;

    IF NEW.age <= 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Age must be greater than 18';
    END IF;
END //

DELIMITER ;

INSERT INTO Employee VALUES
(3, 'Priya', 23, 35000);

SELECT * FROM Employee;
