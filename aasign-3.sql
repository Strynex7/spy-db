CREATE DATABASE IF NOT EXISTS trc_db;
USE trc_db;

CREATE TABLE Student (
    sid INT PRIMARY KEY,
    name VARCHAR(50),
    gpa DECIMAL(3,1),
    dept_id INT
);

CREATE TABLE Course (
    cid INT PRIMARY KEY,
    cname VARCHAR(50),
    credits INT,
    dept_id INT
);

CREATE TABLE Enrollment (
    sid INT,
    cid INT,
    grade CHAR(2),
    PRIMARY KEY (sid, cid),
    FOREIGN KEY (sid) REFERENCES Student(sid),
    FOREIGN KEY (cid) REFERENCES Course(cid)
);

INSERT INTO Student VALUES
(1, 'Kunal', 8.5, 1),
(2, 'Vedant', 7.5, 1),
(3, 'Priya', 9.1, 2),
(4, 'Amit', 7.0, 2),
(5, 'Sneha', 8.8, 1);

INSERT INTO Course VALUES
(101, 'DBMS', 4, 1),
(102, 'DSA', 4, 1),
(103, 'OS', 3, 1),
(104, 'AI', 4, 2),
(105, 'ML', 4, 2),
(106, 'Robotics', 3, 3);

INSERT INTO Enrollment VALUES
(1, 101, 'A'),
(1, 102, 'B'),
(1, 103, 'A'),
(2, 101, 'C'),
(3, 104, 'A'),
(3, 105, 'A'),
(3, 101, 'B'),
(3, 102, 'A'),
(4, 104, 'C'),
(5, 101, 'B'),
(5, 102, 'A');

SELECT * FROM Student WHERE gpa > 8.0;

SELECT * FROM Student s
WHERE NOT EXISTS (
    SELECT * FROM Course c
    WHERE c.dept_id = s.dept_id
    AND NOT EXISTS (
        SELECT * FROM Enrollment e
        WHERE e.sid = s.sid AND e.cid = c.cid
    )
);

SELECT * FROM Course c
WHERE NOT EXISTS (
    SELECT * FROM Enrollment e WHERE e.cid = c.cid
);

SELECT s.sid, s.name, COUNT(e.cid) AS total_courses
FROM Student s
JOIN Enrollment e ON s.sid = e.sid
GROUP BY s.sid, s.name
HAVING COUNT(e.cid) > 3;

SELECT * FROM Student s
WHERE gpa = (
    SELECT MAX(gpa) FROM Student WHERE dept_id = s.dept_id
);
