from flask import request, Flask
import ldap3

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
    conn.search(dn, search_filter)


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
        dn, search_filter)

# if __name__ == "__main__":
#     app.run(debug=True)
