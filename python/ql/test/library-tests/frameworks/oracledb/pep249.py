import oracledb

connection = oracledb.connect(user=u"username", password="password", dsn="connectstring")
cursor = connection.cursor()
cursor.execute("some sql")  # $ getSql="some sql"
