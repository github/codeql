from flask import request, Flask
from ldap import initialize

app = Flask(__name__)


@app.route("/tainted_var")
def tainted_var():
    unsanitized_dn = "dc=%s" % request.args['dc']
    unsanitized_filter = "(&(objectClass=*)(uid=%s))" % request.args['username']

    ldap_connection = initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        unsanitized_dn, ldap.SCOPE_SUBTREE, unsanitized_filter)
    return user[0]


@app.route("/var_tainted")
def var_tainted():
    unsanitized_dn = request.args['dc']
    unsanitized_filter = request.args['username']

    dn = "dc=%s" % unsanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % unsanitized_filter

    ldap_connection = initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
    return user[0]


@app.route("/direct")
def direct():
    ldap_connection = initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        "dc=%s" % request.args['dc'], ldap.SCOPE_SUBTREE, "(&(objectClass=*)(uid=%s))" % request.args['username'])
    return user[0]


@app.route("/with_2")
def with_2():
    sanitized_dn = request.args['dc']
    sanitized_filter = request.args['username']

    dn = "dc=%s" % sanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % sanitized_filter

    with initialize("ldap://127.0.0.1:1337") as ldap_connection:
        user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
        return user[0]

# if __name__ == "__main__":
#     app.run(debug=True)
