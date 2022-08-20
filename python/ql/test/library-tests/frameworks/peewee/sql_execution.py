import peewee
import playhouse.pool

# This is just one example of one of the support databases
# see https://docs.peewee-orm.com/en/latest/peewee/database.html
db = peewee.MySQLDatabase()

conn = db.connection()
cursor = conn.cursor()
cursor.execute("sql")  # $ getSql="sql"

cursor = db.cursor()
cursor.execute("sql")  # $ getSql="sql"

db.execute_sql("sql")  # $ getSql="sql"

# Pool extension
pool = playhouse.pool.PooledMySQLDatabase(...)
pool.execute_sql("sql")  # $ getSql="sql"
