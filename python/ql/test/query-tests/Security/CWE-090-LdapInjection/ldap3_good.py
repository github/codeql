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


@app.route("/paged-keyword")
def paged_keyword():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(escape_rdn(unsafe_dc))
    search_filter = "(user={})".format(escape_filter_chars(unsafe_filter))

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv, user=dn, auto_bind=True)
    conn.extend.standard.paged_search(
        search_base=dn, search_filter=search_filter)


@app.route("/paged-positional")
def paged_positional():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']

    dn = "dc={}".format(escape_rdn(unsafe_dc))
    search_filter = "(user={})".format(escape_filter_chars(unsafe_filter))

    srv = ldap3.Server('ldap://127.0.0.1')
    ldap3.Connection(srv, user=dn, auto_bind=True).extend.standard.paged_search(
        dn, search_filter)


@app.route("/paged-non-sink-arguments")
def paged_non_sink_arguments():
    unsafe = request.args['value']

    srv = ldap3.Server('ldap://127.0.0.1')
    conn = ldap3.Connection(srv)
    conn.extend.standard.paged_search(
        search_base="dc=example,dc=com",
        search_filter="(objectClass=person)",
        attributes=[unsafe],
        controls=unsafe,
        paged_size=unsafe,
        generator=False)


class OtherStandardOperations:
    def paged_search(self, search_base, search_filter):
        pass


class OtherExtensions:
    standard = OtherStandardOperations()


class OtherConnection:
    extend = OtherExtensions()


@app.route("/paged-unrelated")
def paged_unrelated():
    unsafe_dc = request.args['dc']
    unsafe_filter = request.args['username']
    OtherConnection().extend.standard.paged_search(unsafe_dc, unsafe_filter)

# if __name__ == "__main__":
#     app.run(debug=True)
