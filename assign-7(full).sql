CREATE DATABASE EmployeeDB;
USE EmployeeDB;

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    age INT,
    salary DECIMAL(10,2)
);

CREATE TABLE Salary_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Employee VALUES
(1, 'Amit', 22, 25000),
(2, 'Rahul', 25, 30000);

DELIMITER //

CREATE TRIGGER Before_Employee_Insert
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

CREATE TRIGGER After_Employee_Update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO Salary_Audit
        (emp_id, old_salary, new_salary, change_time)
        VALUES
        (NEW.emp_id, OLD.salary, NEW.salary, CURRENT_TIMESTAMP);
    END IF;
END //

DELIMITER ;

INSERT INTO Employee VALUES
(3, 'Priya', 23, 35000);

UPDATE Employee
SET salary = 40000
WHERE emp_id = 1;

SELECT * FROM Employee;

SELECT * FROM Salary_Audit;
