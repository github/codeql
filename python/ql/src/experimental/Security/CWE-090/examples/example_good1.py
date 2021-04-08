from flask import request, Flask
import ldap
import ldap.filter
import ldap.dn


@app.route("/normal")
def normal():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    safe_dn = ldap.dn.escape_dn_chars(unsafe_dn)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        safe_dn, ldap.SCOPE_SUBTREE, safe_filter)
