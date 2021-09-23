# since global options are considered to affect all files in a repo, we need to keep
# this test in its' own directory (so it doesn't interfere with other tests).

import ldap
from flask import request, Flask

app = Flask(__name__)

# GOOD

# SSL through ldap global variable option

ldap.set_option(ldap.OPT_X_TLS_DEMAND, True)


@app.route("/one")
def one():
    # The following connection would have been insecure if the global option above was
    # not set
    ldap_connection_5 = ldap.initialize("ldap://somethingon.theinternet.com")
    ldap_connection_5.simple_bind_s('', '')
    user = ldap_connection_5.search_s(
        "dn", ldap.SCOPE_SUBTREE, "search_filter")

    return user


# if __name__ == "__main__":
#     app.run(debug=True)
