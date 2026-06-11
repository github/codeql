from hdbcli import dbapi

conn = dbapi.connect(address="hostname", port=300, user="username", password="password")
cursor = conn.cursor()

cursor.execute("some sql", (42,))  # $ getSql="some sql"
cursor.executemany("some sql", (42,))  # $ getSql="some sql"

cursor.close()


# ---------------------------------------------------------------------------
# Connection stored in a class attribute and accessed via various patterns
# ---------------------------------------------------------------------------


class WrapperA:
    def __init__(self):
        self._conn = dbapi.connect(address="hostname", port=300, user="username", pass_arg="testpass")

    def get_connection(self):
        return self._conn


# Getter called on a fresh constructor result
conn_a1 = WrapperA().get_connection()
cursor_a1 = conn_a1.cursor()
cursor_a1.execute("some sql", (42,))  # $ MISSING: getSql="some sql"

# Getter called via a stored wrapper instance
wrapper_instance = WrapperA()
conn_a2 = wrapper_instance.get_connection()
cursor_a2 = conn_a2.cursor()
cursor_a2.execute("some sql", (42,))  # $ MISSING: getSql="some sql"

# Direct attribute access on a fresh constructor result
conn_b = WrapperA()._conn
cursor_b = conn_b.cursor()
cursor_b.execute("some sql", (42,))  # $ MISSING: getSql="some sql"


class WrapperB:
    """Stores the connection under a different attribute name."""

    def __init__(self):
        self._hana = dbapi.connect(address="hostname", port=300, user="username", pass_arg="testpass")

    def cursor(self):
        return self._hana.cursor()


# Direct attribute access on a stored instance (mirrors hdb_con3 in the issue)
conn_c = WrapperB()._hana
cursor_c = conn_c.cursor()
cursor_c.execute("some sql", (42,))  # $ MISSING: getSql="some sql"
