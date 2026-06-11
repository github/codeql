from hdbcli import dbapi

conn = dbapi.connect(address="hostname", port=300, user="username", password="password")
cursor = conn.cursor()

cursor.execute("some sql", (42,))  # $ getSql="some sql"
cursor.executemany("some sql", (42,))  # $ getSql="some sql"
    
cursor.close()


# Connection stored in a class attribute (`self._conn`) and used in another method.
#
# This is currently NOT detected: the `Connection::instance()`/`execute()` predicates in
# PEP249.qll are based on type tracking, which cannot follow a value that is stored into a
# `self` attribute in one method and read from a `self` attribute in another method (see the
# `MISSING` markers below). Regular (global) data flow handles this case correctly, so the
# limitation is specific to the type-tracking-based modeling.
class Database:
    def __init__(self):
        self._conn = dbapi.connect(address="hostname", port=300, user="username")

    def get_connection(self):
        return self._conn

    def run_via_getter(self):
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("getter sql")  # $ MISSING: getSql="getter sql"

    def run_direct(self):
        self._conn.execute("direct sql")  # $ MISSING: getSql="direct sql"


db = Database()
db.run_via_getter()
db.run_direct()
