import phoenixdb
import phoenixdb.cursor

database_url = 'http://localhost:8765/'
conn = phoenixdb.connect(database_url, autocommit=True)

cursor = conn.cursor()
cursor.execute("some sql")  # $ getSql="some sql"
