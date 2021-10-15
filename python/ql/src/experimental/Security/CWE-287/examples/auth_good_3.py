from ldap3 import Server, Connection, ALL
from flask import request, Flask
from ldap3.utils.dn import escape_rdn
from ldap3.utils.conv import escape_filter_chars

@app.route("/passwordFromEnv")
def passwordFromEnv():
    dn = "dc={}".format(escape_rdn(request.args['dc']))
    search_filter = "(user={})".format(escape_filter_chars(request.args['search']))

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn',
                      password="SecurePa$$!")
    status, result, response, _ = conn.search(dn, search_filter)
