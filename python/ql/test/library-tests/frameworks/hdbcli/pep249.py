from hdbcli import dbapi

conn = dbapi.connect(address="hostname", port=300, user="username", password="password")
cursor = conn.cursor()

cursor.execute("some sql", (42,))  # $ MISSING: getSql="some sql"
cursor.executemany("some sql", (42,))  # $ MISSING: getSql="some sql"
    
cursor.close()
