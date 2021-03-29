from flask import request, Flask
import ldap3

app = Flask(__name__)


@app.route("/normal")
def normal():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    srv = ldap3.Server('ldap://127.0.0.1', port=1337)
    conn = ldap3.Connection(srv, user=unsafe_dn, auto_bind=True)
    conn.search(unsafe_dn, unsafe_filter, attributes=[
                "testAttr1", "testAttr2"])


@app.route("/normal_noAttrs")
def normal_noAttrs():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    srv = ldap3.Server('ldap://127.0.0.1', port=1337)
    conn = ldap3.Connection(srv, user=unsafe_dn, auto_bind=True)
    conn.search(unsafe_dn, unsafe_filter)


@app.route("/direct")
def direct():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    srv = ldap3.Server('ldap://127.0.0.1', port=1337)
    conn = ldap3.Connection(srv, user=unsafe_dn, auto_bind=True).search(unsafe_dn, unsafe_filter, attributes=[
        "testAttr1", "testAttr2"])

# if __name__ == "__main__":
#     app.run(debug=True)
