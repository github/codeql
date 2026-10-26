from hdbcli import dbapi
from typing import Optional

hdb_con = dbapi.connect(address='localhost', port=30015, user='system', password='Password123')


class DatabaseConnection:

    def __init__(self):
        self._conn = dbapi.connect(address='localhost', port=30015, user='system', password='Password123')

    def get_conn(self):
        return self._conn
  

hdb_con2 = DatabaseConnection().get_conn()
hdb_con3 = DatabaseConnection()._conn

_hana_connection: Optional[DatabaseConnection] = None
def get_conn():
    global _hana_connection
    if _hana_connection is None:
        _hana_connection = DatabaseConnection()
    return _hana_connection.get_conn()
