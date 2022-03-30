from flask import request, Flask
import ldap
import ldap.filter
import ldap.dn


@app.route("/normal")
def normal():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dc = ldap.dn.escape_dn_chars(unsafe_dc)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    dn = "dc={}".format(safe_dc)
    search_filter = "(user={})".format(safe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1")
    user = ldap_connection.search_s(
        dn, ldap.SCOPE_SUBTREE, search_filter)
