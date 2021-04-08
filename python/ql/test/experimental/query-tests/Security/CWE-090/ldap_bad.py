from flask import request, Flask
import ldap

app = Flask(__name__)


@app.route("/normal")
def normal():
    """
    A RemoteFlowSource is used directly as DN and search filter
    """

    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, unsafe_filter)


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is used directly as DN and search filter using a oneline call to .search_s
    """

    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    user = ldap.initialize("ldap://127.0.0.1:1337").search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, unsafe_filter)


@app.route("/normal_argbyname")
def normal_argbyname():
    """
    A RemoteFlowSource is used directly as DN and search filter, while the search filter is specified as
    an argument by name
    """

    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, filterstr=unsafe_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
