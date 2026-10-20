CREATE DATABASE BankingDB;
USE BankingDB;

CREATE TABLE Account (
    acc_no INT PRIMARY KEY,
    acc_name VARCHAR(50),
    balance DECIMAL(10,2)
);

INSERT INTO Account VALUES
(101, 'Amit', 10000),
(102, 'Rahul', 5000),
(103, 'Priya', 8000);

DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN sender INT,
    IN receiver INT,
    IN amt DECIMAL(10,2)
)
BEGIN
    START TRANSACTION;

    UPDATE Account
    SET balance = balance - amt
    WHERE acc_no = sender AND balance >= amt;

    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
    ELSE
        UPDATE Account
        SET balance = balance + amt
        WHERE acc_no = receiver;

        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END //

DELIMITER ;

CALL TransferFunds(101, 102, 2000);

SELECT * FROM Account;
