from flask import request, Flask
from ldap import initialize
import ldap.filter
import ldap.dn

app = Flask(__name__)


@app.route("/tainted_var_2")
def tainted_var_2():
    sanitized_dn = "dc=%s" % ldap.dn.escape_dn_chars(request.args['dc'])
    sanitized_filter = "(&(objectClass=*)(uid=%s))" % ldap.filter.escape_filter_chars(
        request.args['username'])

    ldap_connection = initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        sanitized_dn, ldap.SCOPE_SUBTREE, sanitized_filter)
    return user[0]


@app.route("/var_tainted_2")
def var_tainted_2():
    sanitized_dn = ldap.dn.escape_dn_chars(request.args['dc'])
    sanitized_filter = ldap.filter.escape_filter_chars(
        request.args['username'])

    dn = "dc=%s" % sanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % sanitized_filter

    ldap_connection = initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
    return user[0]


@app.route("/direct_2")
def direct_2():
    ldap_connection = initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s("dc=%s" % ldap.dn.escape_dn_chars(
        request.args['dc']), ldap.SCOPE_SUBTREE, "(&(objectClass=*)(uid=%s))" % ldap.filter.escape_filter_chars(request.args['username']))
    return user[0]


@app.route("/with_2")
def with_2():
    sanitized_dn = ldap.dn.escape_dn_chars(request.args['dc'])
    sanitized_filter = ldap.filter.escape_filter_chars(
        request.args['username'])

    dn = "dc=%s" % sanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % sanitized_filter

    with initialize("ldap://127.0.0.1:1337") as ldap_connection:
        user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
        return user[0]

# if __name__ == "__main__":
#     app.run(debug=True)
