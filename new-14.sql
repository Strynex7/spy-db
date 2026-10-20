
CREATE DATABASE BankingDB;
USE BankingDB;

CREATE TABLE Customer (
    cid INT PRIMARY KEY,
    cname VARCHAR(50),
    city VARCHAR(50),
    manager_id INT
);

CREATE TABLE Account (
    acc_no INT PRIMARY KEY,
    cid INT,
    balance DECIMAL(12,2),
    acc_type VARCHAR(20),
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

CREATE TABLE Bank_Transaction (
    tid INT PRIMARY KEY,
    acc_no INT,
    trans_type VARCHAR(20),
    amount DECIMAL(12,2),
    trans_date DATE,
    FOREIGN KEY (acc_no) REFERENCES Account(acc_no)
);

INSERT INTO Customer VALUES
(101, 'Amit', 'Pune', NULL),
(102, 'Rahul', 'Mumbai', 101),
(103, 'Priya', 'Pune', 101),
(104, 'Neha', 'Nashik', 102);

INSERT INTO Account VALUES
(1001, 101, 50000, 'Savings'),
(1002, 102, 25000, 'Current'),
(1003, 103, 75000, 'Savings');

INSERT INTO Bank_Transaction VALUES
(1, 1001, 'Deposit', 15000, '2026-10-01'),
(2, 1001, 'Withdraw', 5000, '2026-10-02'),
(3, 1002, 'Deposit', 20000, '2026-10-03'),
(4, 1003, 'Transfer', 12000, '2026-10-04');

SELECT Customer.cid, Customer.cname,
       Account.acc_no, Account.balance
FROM Customer
INNER JOIN Account
ON Customer.cid = Account.cid;

SELECT Customer.cid, Customer.cname,
       Account.acc_no, Account.balance
FROM Customer
LEFT JOIN Account
ON Customer.cid = Account.cid;

SELECT C1.cname AS Customer,
       C2.cname AS Manager
FROM Customer C1
LEFT JOIN Customer C2
ON C1.manager_id = C2.cid;

CREATE VIEW Banking_Details_View AS
SELECT Customer.cid, Customer.cname, Customer.city,
       Account.acc_no, Account.acc_type, Account.balance,
       Bank_Transaction.tid, Bank_Transaction.trans_type,
       Bank_Transaction.amount, Bank_Transaction.trans_date
FROM Customer
INNER JOIN Account
ON Customer.cid = Account.cid
INNER JOIN Bank_Transaction
ON Account.acc_no = Bank_Transaction.acc_no;

SELECT * FROM Banking_Details_View;

CREATE VIEW High_Value_Transaction_View AS
SELECT *
FROM Bank_Transaction
WHERE amount > 10000;

SELECT * FROM High_Value_Transaction_View;
