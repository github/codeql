from flask import request, Flask
import ldap
import ldap.filter
import ldap.dn

app = Flask(__name__)


@app.route("/normal")
def normal():
    """
    A RemoteFlowSource is sanitized and used as DN and search filter
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dc = ldap.dn.escape_dn_chars(unsafe_dc)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    dn = "dc={}".format(safe_dc)
    search_filter = "(user={})".format(safe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1")
    user = ldap_connection.search_s(
        dn, ldap.SCOPE_SUBTREE, search_filter)


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is sanitized and used as DN and search filter using a oneline call to .search_s
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dc = ldap.dn.escape_dn_chars(unsafe_dc)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    dn = "dc={}".format(safe_dc)
    search_filter = "(user={})".format(safe_filter)

    user = ldap.initialize("ldap://127.0.0.1").search_s(
        dn, ldap.SCOPE_SUBTREE, search_filter, ["testAttr1", "testAttr2"])


@app.route("/normal_argbyname")
def normal_argbyname():
    """
    A RemoteFlowSource is sanitized and used as DN and search filter, while the search filter is specified as
    an argument by name
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dc = ldap.dn.escape_dn_chars(unsafe_dc)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    dn = "dc={}".format(safe_dc)
    search_filter = "(user={})".format(safe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1")
    user = ldap_connection.search_s(
        dn, ldap.SCOPE_SUBTREE, filterstr=search_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
