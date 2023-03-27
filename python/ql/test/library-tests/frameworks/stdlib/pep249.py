import sqlite3
db = sqlite3.connect("example.db")

# non standard
db.execute("some sql", (42,))  # $ getSql="some sql"

cursor = db.cursor()
cursor.execute("some sql", (42,))  # $ getSql="some sql"
cursor.executescript("sql")  # $ getSql="sql"
cursor.executescript(sql_script="sql") # $ getSql="sql"

import sqlite3.dbapi2
conn = sqlite3.dbapi2.connect()
cursor = conn.cursor()
cursor.execute("some sql") # $ getSql="some sql"
