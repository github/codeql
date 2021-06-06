# taken from https://mysqlclient.readthedocs.io/user_guide.html#some-examples
import MySQLdb
db=MySQLdb.connect(passwd="moonpie",db="thangs")

c=db.cursor()
max_price=5
c.execute("some sql", (max_price,))  # $getSql="some sql"

class Conn:
  def __init__(self):
    self.conn = MySQLdb.connect(passwd="moonpie",db="thangs")

  def query(self, query, params):
    cur = self.conn.cursor()
    cur.execute(query, params)  # $getSql=query
    cur.close()

classconn = Conn()
classconn.query("some sql", (max_price,))
