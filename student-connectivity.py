#pip install mysql-connector-python
import tkinter as tk
from tkinter import messagebox
import mysql.connector

# Database connection
con = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="fair"
)

cur = con.cursor()

# Add record
def add():
    try:
        cur.execute(
            "INSERT INTO Student (id, name, marks) VALUES (%s, %s, %s)",
            (int(id_entry.get()), name_entry.get(), int(marks_entry.get()))
        )
        con.commit()
        messagebox.showinfo("Success", "Record Added")
        view()
    except Exception as e:
        con.rollback()
        messagebox.showerror("Error", str(e))

# View records
def view():
    cur.execute("SELECT * FROM Student")
    records = cur.fetchall()

    result.delete("1.0", tk.END)

    for row in records:
        result.insert(tk.END, str(row) + "\n")

# Edit record
def edit():
    try:
        cur.execute(
            "UPDATE Student SET name=%s, marks=%s WHERE id=%s",
            (name_entry.get(), int(marks_entry.get()), int(id_entry.get()))
        )
        con.commit()

        if cur.rowcount == 0:
            messagebox.showinfo("Info", "No record found or no changes made")
        else:
            messagebox.showinfo("Success", "Record Updated")

        view()
    except Exception as e:
        con.rollback()
        messagebox.showerror("Error", str(e))

# Delete record
def delete():
    try:
        cur.execute(
            "DELETE FROM Student WHERE id=%s",
            (int(id_entry.get()),)
        )
        con.commit()

        if cur.rowcount == 0:
            messagebox.showinfo("Info", "Record not found")
        else:
            messagebox.showinfo("Success", "Record Deleted")

        view()
    except Exception as e:
        con.rollback()
        messagebox.showerror("Error", str(e))

# GUI window
root = tk.Tk()
root.title("Student Database")
root.geometry("400x450")

tk.Label(root, text="Student ID").pack()
id_entry = tk.Entry(root)
id_entry.pack()

tk.Label(root, text="Student Name").pack()
name_entry = tk.Entry(root)
name_entry.pack()

tk.Label(root, text="Marks").pack()
marks_entry = tk.Entry(root)
marks_entry.pack()

tk.Button(root, text="Add", command=add).pack(pady=3)
tk.Button(root, text="View", command=view).pack(pady=3)
tk.Button(root, text="Edit", command=edit).pack(pady=3)
tk.Button(root, text="Delete", command=delete).pack(pady=3)

result = tk.Text(root, height=10, width=45)
result.pack(pady=10)

root.mainloop()

con.close()

