from flask import request, Flask
import ldap


@app.route("/bind_example")
def bind_example():
    dn = request.args['dc']
    search_filter = request.args['search']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind('cn=root', "")
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
