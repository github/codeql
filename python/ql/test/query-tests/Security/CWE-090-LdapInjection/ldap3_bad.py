from flask import request, Flask # $ Source
import ldap3
import ldap3 as l3
from ldap3 import Connection as LdapConnection, Server as LdapServer
from ldap3.utils.dn import escape_rdn
from ldap3.utils.conv import escape_filter_chars

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

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv, user=dn, auto_bind=True)
    conn.search(dn, search_filter) # $ Alert


@app.route("/direct")
def direct():
    """
    A RemoteFlowSource is used directly as DN and search filter using a oneline call to .search
    """

    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(unsafe_dc)
    search_filter = "(user={})".format(unsafe_filter)

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv, user=dn, auto_bind=True).search(
        dn, search_filter) # $ Alert


@app.route("/paged-keyword")
def paged_keyword():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(unsafe_dc)
    search_filter = "(user={})".format(unsafe_filter)

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv, user=dn, auto_bind=True)
    list(conn.extend.standard.paged_search(
        search_base=dn, search_filter=search_filter)) # $ Alert


@app.route("/paged-positional")
def paged_positional():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(unsafe_dc)
    search_filter = "(user={})".format(unsafe_filter)

    srv = ldap3.Server('ldap://127.0.0.1')
    ldap3.Connection(srv, user=dn, auto_bind=True).extend.standard.paged_search(
        dn, search_filter, generator=False) # $ Alert


@app.route("/paged-partially-sanitized")
def paged_partially_sanitized():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    safe_dn = "dc={}".format(escape_rdn(unsafe_dc))
    safe_filter = "(user={})".format(escape_filter_chars(unsafe_filter))

    conn = LdapConnection(LdapServer('ldap://127.0.0.1'))
    conn.extend.standard.paged_search(
        search_filter=safe_filter, search_base="dc={}".format(unsafe_dc), # $ Alert
        generator=False)
    list(conn.extend.standard.paged_search(
        safe_dn, search_filter="(user={})".format(unsafe_filter))) # $ Alert


@app.route("/paged-bound-method")
def paged_bound_method():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    conn = l3.Connection(l3.Server('ldap://127.0.0.1'))
    paged_search = conn.extend.standard.paged_search
    list(paged_search(
        "dc={}".format(unsafe_dc), "(user={})".format(unsafe_filter))) # $ Alert

# if __name__ == "__main__":
#     app.run(debug=True)
