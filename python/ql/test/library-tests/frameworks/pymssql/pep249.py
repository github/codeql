import pymssql
connection = pymssql.connect(host="localhost", user="user", password="passwd")

cursor = connection.cursor()
cursor.execute("some sql", (42,))  # $ getSql="some sql"
cursor.executemany("some sql", [(42,)])  # $ getSql="some sql"
