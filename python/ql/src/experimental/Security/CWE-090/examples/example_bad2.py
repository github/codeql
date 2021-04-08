from flask import request, Flask
import ldap3


@app.route("/normal")
def normal():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    srv = ldap3.Server('ldap://127.0.0.1', port=1337)
    conn = ldap3.Connection(srv, user=unsafe_dn, auto_bind=True)
    conn.search(unsafe_dn, unsafe_filter)
