import ldap3
from flask import request, Flask

app = Flask(__name__)


@app.route("/tainted_var")
def tainted_var():
    unsanitized_dn = "dc=%s" % request.args['dc']
    unsanitized_filter = "(&(objectClass=*)(uid=%s))" % request.args['username']

    srv = ldap3.Server('localhost', port=1337)
    conn = ldap3.Connection(srv, user=unsanitized_dn, auto_bind=True)
    conn.search(unsanitized_dn, unsanitized_filter)
    return conn.response


@app.route("/var_tainted")
def var_tainted():
    unsanitized_dn = request.args['dc']
    unsanitized_filter = request.args['username']

    dn = "dc=%s" % unsanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % unsanitized_filter

    srv = ldap3.Server('localhost', port=1337)
    conn = ldap3.Connection(srv, user=dn, auto_bind=True)
    conn.search(dn, search_filter)
    return conn.response


@app.route("/direct")
def direct():
    srv = ldap3.Server('localhost', port=1337)
    conn = ldap3.Connection(srv, user="dc=%s" %
                            request.args['dc'], auto_bind=True)
    conn.search("dc=%s" % unsanitized_dn,
                "(&(objectClass=*)(uid=%s))" % request.args['username'])
    return conn.response


@app.route("/with_")
def with_():
    unsanitized_dn = request.args['dc']
    unsanitized_filter = request.args['username']

    dn = "dc=%s" % unsanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % unsanitized_filter

    srv = ldap3.Server('localhost', port=1337)
    with ldap3.Connection(server, auto_bind=True) as conn:
        conn.search(dn, search_filter)
        return conn.response

# if __name__ == "__main__":
#     app.run(debug=True)
