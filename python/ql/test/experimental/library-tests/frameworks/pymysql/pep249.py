import pymysql
connection = pymysql.connect(host="localhost", user="user", password="passwd")

cursor = connection.cursor()
cursor.execute("some sql", (42,))  # $ getSql="some sql"
