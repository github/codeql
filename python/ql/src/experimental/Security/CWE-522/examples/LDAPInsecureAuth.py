from ldap3 import Server, Connection, ALL
from flask import request, Flask

app = Flask(__name__)


@app.route("/good")
def good():
    srv = Server(host, port, use_ssl=True)
    conn = Connection(srv, dn, password)
    conn.search(dn, search_filter)
    return conn.response


@app.route("/bad")
def bad():
    srv = Server(host, port)
    conn = Connection(srv, dn, password)
    conn.search(dn, search_filter)
    return conn.response
