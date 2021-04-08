from ldap3 import Server, Connection, ALL
from flask import request, Flask
import os


@app.route("/passwordFromEnv")
def passwordFromEnv():
    dn = request.args['dc']
    search_filter = request.args['search']

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn',
                      password=os.environ.get('LDAP_PASSWORD'))
    status, result, response, _ = conn.search(dn, search_filter)
