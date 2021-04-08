from flask import request, Flask
import ldap


@app.route("/normal")
def normal():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, unsafe_filter)
