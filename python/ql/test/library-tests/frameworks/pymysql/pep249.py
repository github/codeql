import pymysql
connection = pymysql.connect(host="localhost", user="user", password="passwd")

cursor = connection.cursor()
cursor.execute("some sql", (42,))  # $ getSql="some sql"

class Conn:
  def __init__(self):
    self.conn = pymysql.connect(host="localhost", user="user", password="passwd")

  def query(self, query, params):
    cur = self.conn.cursor()
    cur.execute(query, params)  # $getSql=query
    cur.close()

classconn = Conn()
classconn.query("some sql", (42,))
