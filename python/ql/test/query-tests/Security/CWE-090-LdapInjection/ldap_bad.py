from flask import request, Flask
import ldap

app = Flask(__name__)


@app.route("/normal")
def normal():
    """
    A RemoteFlowSource is used directly as DN and search filter
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(unsafe_dc)
    search_filter = "(user={})".format(unsafe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1")
    user = ldap_connection.search_s(
        dn, ldap.SCOPE_SUBTREE, search_filter)


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is used directly as DN and search filter using a oneline call to .search_s
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(unsafe_dc)
    search_filter = "(user={})".format(unsafe_filter)

    user = ldap.initialize("ldap://127.0.0.1").search_s(
        dn, ldap.SCOPE_SUBTREE, search_filter)


@app.route("/normal_argbyname")
def normal_argbyname():
    """
    A RemoteFlowSource is used directly as DN and search filter, while the search filter is specified as
    an argument by name
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(unsafe_dc)
    search_filter = "(user={})".format(unsafe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1")
    user = ldap_connection.search_s(
        dn, ldap.SCOPE_SUBTREE, filterstr=search_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
