import oracledb

connection = oracledb.connect(user="username", password="password", dsn="connectstring")
cursor = connection.cursor()
cursor.execute("some sql")  # $ getSql="some sql"
