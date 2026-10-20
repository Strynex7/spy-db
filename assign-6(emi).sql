
CREATE DATABASE BankingDB;
USE BankingDB;

CREATE TABLE IF NOT EXISTS Customer (
    cid INT PRIMARY KEY,
    cname VARCHAR(50),
    city VARCHAR(50),
    manager_id INT
);

CREATE TABLE IF NOT EXISTS Account (
    acc_no INT PRIMARY KEY,
    cid INT,
    balance DECIMAL(10,2),
    acc_type VARCHAR(20),
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

CREATE TABLE IF NOT EXISTS `Transaction` (
    tid INT PRIMARY KEY,
    acc_no INT,
    amount DECIMAL(10,2),
    t_date DATE,
    FOREIGN KEY (acc_no) REFERENCES Account(acc_no)
);

INSERT IGNORE INTO Customer VALUES
(101, 'Rahul', 'Pune', 1),
(102, 'Amit', 'Mumbai', 2);

INSERT IGNORE INTO Account VALUES
(1001, 101, 25000.00, 'Savings'),
(1002, 101, 40000.00, 'Current'),
(1003, 102, 30000.00, 'Savings');

INSERT IGNORE INTO `Transaction` VALUES
(1, 1001, 5000.00, '2026-10-18'),
(2, 1001, 2000.00, '2026-10-19'),
(3, 1002, 3000.00, '2026-10-20'),
(4, 1003, 7000.00, '2026-10-20');

DROP FUNCTION IF EXISTS Loan_EMI;

DELIMITER //

CREATE FUNCTION Loan_EMI(
    P DECIMAL(12,2),
    R DECIMAL(5,2),
    N INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE EMI DECIMAL(12,2);
    DECLARE RATE DECIMAL(10,8);

    IF N <= 0 OR P < 0 OR R < 0 THEN
        RETURN NULL;
    END IF;

    SET RATE = R / (12 * 100);

    IF RATE = 0 THEN
        SET EMI = P / N;
    ELSE
        SET EMI = P * RATE * POW(1 + RATE, N)
                  / (POW(1 + RATE, N) - 1);
    END IF;

    RETURN ROUND(EMI, 2);
END //

DELIMITER ;

SELECT Loan_EMI(100000, 12, 12) AS Monthly_EMI;

DROP PROCEDURE IF EXISTS Show_Transactions;

DELIMITER //

CREATE PROCEDURE Show_Transactions(IN C_ID INT)
BEGIN
    DECLARE DONE INT DEFAULT 0;
    DECLARE V_TID INT;
    DECLARE V_ACC_NO INT;
    DECLARE V_AMOUNT DECIMAL(10,2);
    DECLARE V_DATE DATE;

    DECLARE C_TRANS CURSOR FOR
        SELECT T.tid, T.acc_no, T.amount, T.t_date
        FROM `Transaction` T
        JOIN Account A ON T.acc_no = A.acc_no
        WHERE A.cid = C_ID;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET DONE = 1;

    OPEN C_TRANS;

    FETCH_LOOP: LOOP
        FETCH C_TRANS
        INTO V_TID, V_ACC_NO, V_AMOUNT, V_DATE;

        IF DONE = 1 THEN
            LEAVE FETCH_LOOP;
        END IF;

        SELECT
            V_TID AS Transaction_ID,
            V_ACC_NO AS Account_Number,
            V_AMOUNT AS Amount,
            V_DATE AS Transaction_Date;
    END LOOP;

    CLOSE C_TRANS;
END //

DELIMITER ;

CALL Show_Transactions(101);
