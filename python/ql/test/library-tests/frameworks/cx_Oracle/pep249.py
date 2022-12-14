import cx_Oracle
connection = cx_Oracle.connect(user="hr", password="pwd",
                               dsn="dbhost.example.com/orclpdb1")

cursor = connection.cursor()
cursor.execute("some sql")  # $ getSql="some sql"
