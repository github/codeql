import ldap
from flask import request, Flask

app = Flask(__name__)

schema = "ldap://"
remote_host = "127.0.0.1"
full_host = "ldap://127.0.0.1"


# GOOD

# SSL through ldap variable option
# host from variable + variable

@app.route("/one")
def one():
    ldap_connection_1 = ldap.initialize(schema + remote_host)
    ldap_connection_1.set_option(ldap.OPT_X_TLS_DEMAND, True)
    ldap_connection_1.simple_bind_s('', '')
    user = ldap_connection_1.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


# SSL through ldap start_tls_s
# hardcoded host

@app.route("/two")
def two():
    ldap_connection_2 = ldap.initialize("ldap://127.0.0.1")
    ldap_connection_2.start_tls_s()
    ldap_connection_2.simple_bind_s('', '')
    user = ldap_connection_2.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


# BAD (not a sink because it's private)

@app.route("/one_bad")
def one_bad():
    ldap_connection_3 = ldap.initialize(schema + remote_host)
    ldap_connection_3.set_option(ldap.OPT_X_TLS_DEMAND, False)
    ldap_connection_3.simple_bind_s('', '')
    user = ldap_connection_3.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


@app.route("/one_bad_2")
def one_bad_2():
    ldap_connection_4 = ldap.initialize(schema + remote_host)
    ldap_connection_4.set_option(ldap.OPT_X_TLS_NEVER, True)
    ldap_connection_4.simple_bind_s('', '')
    user = ldap_connection_4.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


# if __name__ == "__main__":
#     app.run(debug=True)
