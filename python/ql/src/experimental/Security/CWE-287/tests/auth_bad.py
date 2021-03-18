from flask import request, Flask
import ldap

app = Flask(__name__)


@app.route("/simple_bind")
def simple_bind():
    dn = request.args['dc']
    search_filter = request.args['search']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.simple_bind('cn=root')
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
    return user[0]


@app.route("/simple_bind_s")
def simple_bind_s():
    dn = request.args['dc']
    search_filter = request.args['search']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.simple_bind_s('cn=root')
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
    return user[0]


@app.route("/bind_s")
def bind_s():
    dn = request.args['dc']
    search_filter = request.args['search']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind_s('cn=root', None)
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
    return user[0]


@app.route("/bind")
def bind():
    dn = request.args['dc']
    search_filter = request.args['search']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind('cn=root', None)
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)
    return user[0]


# if __name__ == "__main__":
#     app.run(debug=True)
