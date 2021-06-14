from flask import request, Flask
import ldap3
from ldap3.utils.dn import escape_rdn
from ldap3.utils.conv import escape_filter_chars


@app.route("/normal")
def normal():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dc = escape_rdn(unsafe_dc)
    safe_filter = escape_filter_chars(unsafe_filter)

    dn = "dc={}".format(safe_dc)
    search_filter = "(user={})".format(safe_filter)

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv, user=dn, auto_bind=True)
    conn.search(dn, search_filter)
