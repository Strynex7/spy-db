use StudentDB

db.createCollection("students")

db.students.insertMany([
    {
        rollno: 1,
        name: "Amit",
        department: "AI&DS",
        marks: [
            { course: "DBMS", score: 85 },
            { course: "MongoDB", score: 90 },
            { course: "Python", score: 80 }
        ]
    },
    {
        rollno: 2,
        name: "Rahul",
        department: "Computer",
        marks: [
            { course: "DBMS", score: 75 },
            { course: "MongoDB", score: 80 },
            { course: "Python", score: 85 }
        ]
    },
    {
        rollno: 3,
        name: "Priya",
        department: "AI&DS",
        marks: [
            { course: "DBMS", score: 95 },
            { course: "MongoDB", score: 92 },
            { course: "Python", score: 96 }
        ]
    },
    {
        rollno: 4,
        name: "Sneha",
        department: "Computer",
        marks: [
            { course: "DBMS", score: 88 },
            { course: "MongoDB", score: 85 },
            { course: "Python", score: 90 }
        ]
    },
    {
        rollno: 5,
        name: "Karan",
        department: "IT",
        marks: [
            { course: "DBMS", score: 70 },
            { course: "MongoDB", score: 75 },
            { course: "Python", score: 78 }
        ]
    }
])

db.students.aggregate([
    { $unwind: "$marks" },
    {
        $group: {
            _id: "$department",
            averageMarks: { $avg: "$marks.score" }
        }
    }
])

db.students.aggregate([
    { $unwind: "$marks" },
    {
        $group: {
            _id: "$marks.course",
            highestMarks: { $max: "$marks.score" }
        }
    }
])

db.students.aggregate([
    {
        $group: {
            _id: "$department",
            totalStudents: { $sum: 1 }
        }
    }
])

db.students.aggregate([
    { $unwind: "$marks" },
    {
        $group: {
            _id: {
                rollno: "$rollno",
                name: "$name",
                department: "$department"
            },
            averageMarks: { $avg: "$marks.score" }
        }
    },
    { $sort: { averageMarks: -1 } },
    { $limit: 3 }
])

db.students.aggregate([
    { $unwind: "$marks" },
    {
        $group: {
            _id: {
                rollno: "$rollno",
                name: "$name",
                department: "$department"
            },
            averageMarks: { $avg: "$marks.score" }
        }
    },
    { $sort: { averageMarks: -1 } },
    {
        $group: {
            _id: "$_id.department",
            topStudent: { $first: "$_id.name" },
            averageMarks: { $first: "$averageMarks" }
        }
    }
])

db.students.aggregate([
    { $unwind: "$marks" },
    {
        $group: {
            _id: {
                rollno: "$rollno",
                name: "$name"
            },
            totalMarks: { $sum: "$marks.score" }
        }
    }
])
