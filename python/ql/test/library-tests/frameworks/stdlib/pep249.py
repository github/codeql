import sqlite3
db = sqlite3.connect("example.db")

# non standard
db.execute("some sql", (42,))  # $ getSql="some sql"

cursor = db.cursor()
cursor.execute("some sql", (42,))  # $ getSql="some sql"
