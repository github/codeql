import ldap
from flask import request, Flask

app = Flask(__name__)

schema = "ldap://"
remote_host = "somethingon.theinternet.com"
full_host = "ldap://somethingon.theinternet.com"


# GOOD

# SSL through ldap variable option
# host from variable + variable

@app.route("/one")
def one():
    ldap_connection_5 = ldap.initialize(schema + remote_host)
    ldap_connection_5.set_option(ldap.OPT_X_TLS_DEMAND, True)
    ldap_connection_5.simple_bind_s('', '')
    user = ldap_connection_5.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


# SSL through ldap start_tls_s
# hardcoded host

@app.route("/two")
def two():
    ldap_connection_6 = ldap.initialize("ldap://somethingon.theinternet.com")
    ldap_connection_6.start_tls_s()
    ldap_connection_6.simple_bind_s('', '')
    user = ldap_connection_6.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


# BAD

@app.route("/one_bad")
def one_bad():
    ldap_connection_7 = ldap.initialize(schema + remote_host)
    ldap_connection_7.set_option(ldap.OPT_X_TLS_DEMAND, False)
    ldap_connection_7.simple_bind_s('', '')
    user = ldap_connection_7.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


@app.route("/one_bad_2")
def one_bad_2():
    ldap_connection_8 = ldap.initialize(schema + remote_host)
    ldap_connection_8.set_option(ldap.OPT_X_TLS_NEVER, True)
    ldap_connection_8.simple_bind_s('', '')
    user = ldap_connection_8.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


# if __name__ == "__main__":
#     app.run(debug=True)
