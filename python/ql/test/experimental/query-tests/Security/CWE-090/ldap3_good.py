from flask import request, Flask
import ldap3
from ldap3.utils.dn import escape_rdn
from ldap3.utils.conv import escape_filter_chars

app = Flask(__name__)


@app.route("/normal")
def normal():
    """
    A RemoteFlowSource is sanitized and used as DN and search filter
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dc = escape_rdn(unsafe_dc)
    safe_filter = escape_filter_chars(unsafe_filter)

    dn = "dc={}".format(safe_dc)
    search_filter = "(user={})".format(safe_filter)

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv, user=dn, auto_bind=True)
    conn.search(dn, search_filter)


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is sanitized and used as DN and search filter using a oneline call to .search
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dc = escape_rdn(unsafe_dc)
    safe_filter = escape_filter_chars(unsafe_filter)

    dn = "dc={}".format(safe_dc)
    search_filter = "(user={})".format(safe_filter)

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv, user=dn, auto_bind=True).search(
        dn, search_filter)

# if __name__ == "__main__":
#     app.run(debug=True)
