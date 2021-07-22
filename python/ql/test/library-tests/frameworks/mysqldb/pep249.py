# taken from https://mysqlclient.readthedocs.io/user_guide.html#some-examples
import MySQLdb
db=MySQLdb.connect(passwd="moonpie",db="thangs")

c=db.cursor()
max_price=5
c.execute("some sql", (max_price,))  # $getSql="some sql"