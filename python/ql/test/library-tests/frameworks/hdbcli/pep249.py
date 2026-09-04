from hdbcli import dbapi

conn = dbapi.connect(address="hostname", port=300, user="username", password="password")
cursor = conn.cursor()

cursor.execute("some sql", (42,))  # $ getSql="some sql"
cursor.executemany("some sql", (42,))  # $ getSql="some sql"
    
cursor.close()


# Connection stored in a class attribute (`self._conn`) and used in another method.
#
# This is detected because type tracking includes a level step modelling flow through
# instance attributes: a value written to `self._conn` in one method (here `__init__`) can
# be read back from `self._conn` (directly or via a getter) in any other method on the same
# class. This follows the same approach used for instance fields in Ruby and JavaScript.
class Database:
    def __init__(self):
        self._conn = dbapi.connect(address="hostname", port=300, user="username")

    def get_connection(self):
        return self._conn

    def run_via_getter(self):
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("getter sql")  # $ getSql="getter sql"

    def run_direct(self):
        self._conn.execute("direct sql")  # $ getSql="direct sql"


db = Database()
db.run_via_getter()
db.run_direct()
