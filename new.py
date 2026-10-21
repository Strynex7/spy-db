import mysql.connector
from mysql.connector import Error

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "root",
}
DB_NAME = "student_db"


def connect():
    con = mysql.connector.connect(**DB_CONFIG)
    cur = con.cursor()
    cur.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME}")
    cur.execute(f"USE {DB_NAME}")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS students (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(100) NOT NULL,
            marks INT NOT NULL
        )
    """)
    con.commit()
    return con, cur


def get_int(prompt, low=None, high=None):
    while True:
        try:
            value = int(input(prompt))
            if (low is not None and value < low) or (high is not None and value > high):
                print(f"Please enter a number between {low} and {high}.")
                continue
            return value
        except ValueError:
            print("Invalid input. Please enter a number.")


def get_name(prompt):
    while True:
        name = input(prompt).strip()
        if name:
            return name
        print("Name cannot be empty.")


def print_table(rows):
    if not rows:
        print("No records found.")
        return
    print("\n" + "-" * 38)
    print(f"{'ID':<6}{'Name':<22}{'Marks':<8}")
    print("-" * 38)
    for sid, name, marks in rows:
        print(f"{sid:<6}{name:<22}{marks:<8}")
    print("-" * 38)


def add_record(con, cur):
    name = get_name("Enter name: ")
    marks = get_int("Enter marks (0-100): ", 0, 100)
    cur.execute("INSERT INTO students(name, marks) VALUES(%s, %s)", (name, marks))
    con.commit()
    print(f"Record added successfully (ID = {cur.lastrowid})")


def view_records(cur):
    cur.execute("SELECT id, name, marks FROM students ORDER BY id")
    print_table(cur.fetchall())


def search_records(cur):
    keyword = input("Enter name to search: ").strip()
    cur.execute("SELECT id, name, marks FROM students WHERE name LIKE %s ORDER BY id",
                (f"%{keyword}%",))
    print_table(cur.fetchall())


def edit_record(con, cur):
    sid = get_int("Enter student ID to edit: ")
    cur.execute("SELECT name, marks FROM students WHERE id=%s", (sid,))
    row = cur.fetchone()
    if not row:
        print("ID not found")
        return
    print(f"Current -> Name: {row[0]}, Marks: {row[1]}")
    name = input("Enter new name (press Enter to keep same): ").strip() or row[0]
    marks_in = input("Enter new marks (press Enter to keep same): ").strip()
    marks = row[1]
    if marks_in:
        try:
            marks = int(marks_in)
        except ValueError:
            print("Invalid marks. Keeping old marks.")
    cur.execute("UPDATE students SET name=%s, marks=%s WHERE id=%s", (name, marks, sid))
    con.commit()
    print("Record updated")


def delete_record(con, cur):
    sid = get_int("Enter student ID to delete: ")
    cur.execute("SELECT name FROM students WHERE id=%s", (sid,))
    row = cur.fetchone()
    if not row:
        print("ID not found")
        return
    confirm = input(f"Delete '{row[0]}'? (y/n): ").strip().lower()
    if confirm == 'y':
        cur.execute("DELETE FROM students WHERE id=%s", (sid,))
        con.commit()
        print("Record deleted")
    else:
        print("Deletion cancelled")


def navigate_records(cur):
    cur.execute("SELECT id, name, marks FROM students ORDER BY id")
    rows = cur.fetchall()
    if not rows:
        print("No records found.")
        return
    i = 0
    while True:
        sid, name, marks = rows[i]
        print(f"\nRecord {i + 1} of {len(rows)} -> ID: {sid} | Name: {name} | Marks: {marks}")
        c = input("[F]irst  [N]ext  [P]revious  [L]ast  [Q]uit: ").strip().upper()
        if c == 'F':
            i = 0
        elif c == 'N':
            if i < len(rows) - 1:
                i += 1
            else:
                print("Already at the last record.")
        elif c == 'P':
            if i > 0:
                i -= 1
            else:
                print("Already at the first record.")
        elif c == 'L':
            i = len(rows) - 1
        elif c == 'Q':
            break
        else:
            print("Invalid choice")


def main():
    try:
        con, cur = connect()
        print("Connected to MySQL successfully.")
    except Error as e:
        print("Database connection failed:", e)
        return

    try:
        while True:
            print("\n===== STUDENT DATABASE =====")
            print("1. Add     2. View     3. Edit     4. Delete")
            print("5. Search  6. Navigate 7. Exit")
            ch = input("Enter choice: ").strip()

            try:
                if ch == '1':
                    add_record(con, cur)
                elif ch == '2':
                    view_records(cur)
                elif ch == '3':
                    edit_record(con, cur)
                elif ch == '4':
                    delete_record(con, cur)
                elif ch == '5':
                    search_records(cur)
                elif ch == '6':
                    navigate_records(cur)
                elif ch == '7':
                    print("Goodbye!")
                    break
                else:
                    print("Invalid choice")
            except Error as e:
                con.rollback()
                print("Database error:", e)
    finally:
        cur.close()
        con.close()


if __name__ == "__main__":
    main()
