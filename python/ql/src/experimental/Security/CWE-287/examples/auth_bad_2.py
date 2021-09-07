from flask import request, Flask
import ldap
import ldap.filter
import ldap.dn


@app.route("/bind_example")
def bind_example():
    dn = "dc={}".format(ldap.dn.escape_dn_chars(request.args['dc']))
    search_filter = "(user={})".format(ldap.filter.escape_filter_chars(request.args['search']))

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind('cn=root', "")
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
