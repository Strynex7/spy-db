CREATE DATABASE OnlineLibrary;
USE OnlineLibrary;

CREATE TABLE Member (
    mid INT PRIMARY KEY,
    mname VARCHAR(50)
);

CREATE TABLE Category (
    categoryId INT PRIMARY KEY,
    categoryname VARCHAR(50)
);

CREATE TABLE Book (
    bid INT PRIMARY KEY,
    bname VARCHAR(100),
    categoryId INT,
    FOREIGN KEY (categoryId)
        REFERENCES Category(categoryId)
);

CREATE TABLE Borrow (
    mid INT,
    bid INT,
    borrow_date DATE,
    FOREIGN KEY (mid) REFERENCES Member(mid),
    FOREIGN KEY (bid) REFERENCES Book(bid)
);




INSERT INTO Member VALUES
(101, 'Kunal'),
(102, 'Aisha'),
(103, 'Rahul'),
(104, 'Priya'),
(105, 'Amit'),
(106, 'Neha');

INSERT INTO Category VALUES
(1, 'Technology'),
(2, 'Science'),
(3, 'History'),
(4, 'Fiction'),
(5, 'Business');

INSERT INTO Book VALUES
(1, 'DBMS', 1),
(2, 'Python', 1),
(3, 'Physics', 2),
(4, 'Chemistry', 2),
(5, 'Indian History', 3),
(6, 'World History', 3),
(7, 'Novel A', 4),
(8, 'Novel B', 4),
(9, 'Marketing', 5),
(10, 'Data Science', 1),
(11, 'Biology', 2),
(12, 'Economics', 5);

INSERT INTO Borrow VALUES
(101, 1, '2026-09-02'),
(101, 2, '2026-09-04'),
(101, 3, '2026-09-06'),
(101, 5, '2026-09-08'),
(101, 7, '2026-09-10'),
(101, 9, '2026-09-12'),
(102, 1, '2026-08-10'),
(102, 3, '2026-08-15'),
(102, 5, '2026-07-10'),
(102, 7, '2026-06-10'),
(103, 2, '2025-12-01'),
(104, 4, '2025-10-01'),
(105, 8, '2026-09-15');



SELECT m.mid, m.mname, COUNT(*) AS total_books
FROM Member m
JOIN Borrow b ON m.mid = b.mid
WHERE b.borrow_date >= '2026-09-01'
  AND b.borrow_date < '2026-10-01'
GROUP BY m.mid, m.mname
HAVING COUNT(*) > 5;



SELECT bk.bid, bk.bname
FROM Book bk
LEFT JOIN Borrow b
    ON bk.bid = b.bid
   AND b.borrow_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
WHERE b.bid IS NULL;


SELECT m.mid, m.mname
FROM Member m
LEFT JOIN Borrow b ON m.mid = b.mid
WHERE b.mid IS NULL;


SELECT bk.bid, bk.bname
FROM Book bk
JOIN Borrow b ON bk.bid = b.bid
WHERE b.mid = 101;


SELECT m.mid, m.mname,
       COUNT(DISTINCT bk.categoryId) AS total_categories
FROM Member m
JOIN Borrow b ON m.mid = b.mid
JOIN Book bk ON b.bid = bk.bid
GROUP BY m.mid, m.mname
HAVING COUNT(DISTINCT bk.categoryId) > 3;
