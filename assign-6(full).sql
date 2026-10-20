CREATE DATABASE BankingDB;
USE BankingDB;

CREATE TABLE Customer (
    cid INT PRIMARY KEY,
    cname VARCHAR(50)
);

CREATE TABLE Account (
    acc_no INT PRIMARY KEY,
    cid INT,
    balance DECIMAL(10,2),
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

CREATE TABLE `Transaction` (
    tid INT AUTO_INCREMENT PRIMARY KEY,
    acc_no INT,
    amount DECIMAL(10,2),
    trans_type VARCHAR(20),
    trans_date DATE,
    FOREIGN KEY (acc_no) REFERENCES Account(acc_no)
);

INSERT INTO Customer VALUES
(1, 'Amit'),
(2, 'Rahul');

INSERT INTO Account VALUES
(101, 1, 10000),
(102, 2, 5000);

DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN sender INT,
    IN receiver INT,
    IN amt DECIMAL(10,2)
)
BEGIN
    IF amt <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Amount must be positive';
    ELSEIF sender = receiver THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Accounts must be different';
    ELSE
        START TRANSACTION;

        UPDATE Account
        SET balance = balance - amt
        WHERE acc_no = sender AND balance >= amt;

        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid account or insufficient balance';
        ELSE
            UPDATE Account
            SET balance = balance + amt
            WHERE acc_no = receiver;

            IF ROW_COUNT() = 0 THEN
                ROLLBACK;
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Receiver account not found';
            ELSE
                INSERT INTO `Transaction`
                (acc_no, amount, trans_type, trans_date)
                VALUES
                (sender, amt, 'Transfer Out', CURDATE()),
                (receiver, amt, 'Transfer In', CURDATE());

                COMMIT;
            END IF;
        END IF;
    END IF;
END //

CREATE FUNCTION CalculateEMI(
    principal DECIMAL(12,2),
    rate DECIMAL(8,4),
    months INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE monthly_rate DECIMAL(12,8);

    SET monthly_rate = rate / (12 * 100);

    IF principal <= 0 OR months <= 0 OR rate < 0 THEN
        RETURN NULL;
    ELSEIF rate = 0 THEN
        RETURN ROUND(principal / months, 2);
    ELSE
        RETURN ROUND(
            principal * monthly_rate * POW(1 + monthly_rate, months)
            / (POW(1 + monthly_rate, months) - 1),
            2
        );
    END IF;
END //

CREATE PROCEDURE ShowTransactions(IN customer_id INT)
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE t_id INT;
    DECLARE a_no INT;
    DECLARE amt DECIMAL(10,2);
    DECLARE t_type VARCHAR(20);
    DECLARE t_date DATE;

    DECLARE cur CURSOR FOR
        SELECT t.tid, t.acc_no, t.amount, t.trans_type, t.trans_date
        FROM `Transaction` t
        JOIN Account a ON t.acc_no = a.acc_no
        WHERE a.cid = customer_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO t_id, a_no, amt, t_type, t_date;

        IF finished = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT t_id AS Transaction_ID,
               a_no AS Account_Number,
               amt AS Amount,
               t_type AS Transaction_Type,
               t_date AS Transaction_Date;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL TransferFunds(101, 102, 1000);

SELECT CalculateEMI(100000, 10, 12) AS Monthly_EMI;

CALL ShowTransactions(1);

SELECT * FROM Account;
SELECT * FROM `Transaction`;
