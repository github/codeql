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

    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    safe_dn = ldap.dn.escape_dn_chars(unsafe_dn)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        safe_dn, ldap.SCOPE_SUBTREE, safe_filter)


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is sanitized and used as DN and search filter using a oneline call to .search_s
    """

    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    safe_dn = ldap.dn.escape_dn_chars(unsafe_dn)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    user = ldap.initialize("ldap://127.0.0.1:1337").search_s(
        safe_dn, ldap.SCOPE_SUBTREE, safe_filter, ["testAttr1", "testAttr2"])


@app.route("/normal_argbyname")
def normal_argbyname():
    """
    A RemoteFlowSource is sanitized and used as DN and search filter, while the search filter is specified as
    an argument by name
    """

    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    safe_dn = ldap.dn.escape_dn_chars(unsafe_dn)
    safe_filter = ldap.filter.escape_filter_chars(unsafe_filter)

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        safe_dn, ldap.SCOPE_SUBTREE, filterstr=safe_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
