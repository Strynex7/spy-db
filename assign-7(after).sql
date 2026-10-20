CREATE DATABASE EmployeeDB;
USE EmployeeDB;

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
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
(1, 'Amit', 25000),
(2, 'Rahul', 30000);

DELIMITER //

CREATE TRIGGER Salary_Update
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

UPDATE Employee
SET salary = 35000
WHERE emp_id = 1;

SELECT * FROM Salary_Audit;
