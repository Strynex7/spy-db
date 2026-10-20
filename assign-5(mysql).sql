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
    balance DECIMAL(10,2),
    acc_type VARCHAR(20),
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

CREATE TABLE Transaction (
    tid INT PRIMARY KEY,
    acc_no INT,
    amount DECIMAL(10,2),
    trans_type VARCHAR(20),
    trans_date DATE,
    FOREIGN KEY (acc_no) REFERENCES Account(acc_no)
);

INSERT INTO Customer VALUES
(1, 'Amit', 'Pune', NULL),
(2, 'Rahul', 'Mumbai', 1),
(3, 'Priya', 'Pune', 1),
(4, 'Sneha', 'Nashik', 2);

INSERT INTO Account VALUES
(101, 1, 50000, 'Savings'),
(102, 2, 30000, 'Current'),
(103, 3, 70000, 'Savings'),
(104, 4, 20000, 'Current');

INSERT INTO Transaction VALUES
(1, 101, 5000, 'Deposit', '2026-01-10'),
(2, 102, 2000, 'Withdraw', '2026-01-11'),
(3, 103, 10000, 'Deposit', '2026-01-12'),
(4, 104, 3000, 'Withdraw', '2026-01-13');

SELECT cname
FROM Customer
WHERE cid IN (
    SELECT cid
    FROM Account
    WHERE balance > (
        SELECT AVG(balance)
        FROM Account
    )
);

SELECT acc_no, cid
FROM Account
WHERE acc_type = 'Savings'
UNION
SELECT acc_no, cid
FROM Account
WHERE balance > 40000;

SELECT acc_no, cid
FROM Account
WHERE acc_type = 'Savings'
INTERSECT
SELECT acc_no, cid
FROM Account
WHERE balance > 40000;

SELECT acc_no, cid
FROM Account
WHERE acc_type = 'Savings'
MINUS
SELECT acc_no, cid
FROM Account
WHERE balance > 40000;

SELECT Customer.cid, Customer.cname, Account.acc_no, Account.balance
FROM Customer
INNER JOIN Account
ON Customer.cid = Account.cid;

SELECT Customer.cid, Customer.cname, Account.acc_no, Account.balance
FROM Customer
LEFT JOIN Account
ON Customer.cid = Account.cid;

SELECT C1.cname AS Customer, C2.cname AS Manager
FROM Customer C1
LEFT JOIN Customer C2
ON C1.manager_id = C2.cid;

SELECT Customer.cname, Account.acc_no, Transaction.amount, Transaction.trans_type
FROM Customer
INNER JOIN Account
ON Customer.cid = Account.cid
INNER JOIN Transaction
ON Account.acc_no = Transaction.acc_no;
