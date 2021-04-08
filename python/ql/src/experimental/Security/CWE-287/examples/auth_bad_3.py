from ldap3 import Server, Connection, ALL
from flask import request, Flask


@app.route("/passwordNone")
def passwordNone():
    dn = request.args['dc']
    search_filter = request.args['search']

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn', password=None)
    status, result, response, _ = conn.search(dn, search_filter)
