from ldap3 import Server, Connection
from ldap3.utils.conv import escape_filter_chars
from flask import request, Flask

app = Flask(__name__)


@app.route("/tainted_var")
def tainted_var():
    sanitized_dn = "dc=%s" % request.args['dc']
    sanitized_filter = "(&(objectClass=*)(uid=%s))" % escape_filter_chars(
        request.args['username'])

    srv = Server('localhost', port=1337)
    conn = Connection(srv, user=sanitized_dn, auto_bind=True)
    conn.search(sanitized_dn, sanitized_filter)
    return conn.response


@app.route("/var_tainted")
def var_tainted():
    sanitized_dn = request.args['dc']
    sanitized_filter = request.args['username']

    dn = "dc=%s" % sanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % escape_filter_chars(sanitized_filter)

    srv = Server('localhost', port=1337)
    conn = Connection(srv, user=dn, auto_bind=True)
    conn.search(dn, search_filter)
    return conn.response


@app.route("/direct")
def direct():
    srv = Server('localhost', port=1337)
    conn = Connection(srv, user="dc=%s" % request.args['dc'], auto_bind=True)
    conn.search("dc=%s" % request.args['dc'], "(&(objectClass=*)(uid=%s))" %
                escape_filter_chars(request.args['username']))
    return conn.response


@app.route("/with_2")
def with_2():
    sanitized_dn = request.args['dc']
    sanitized_filter = escape_filter_chars(request.args['username'])

    dn = "dc=%s" % sanitized_dn
    search_filter = "(&(objectClass=*)(uid=%s))" % sanitized_filter

    srv = Server('localhost', port=1337)
    with Connection(server, auto_bind=True) as conn:
        conn.search(dn, search_filter)
        return conn.response

# if __name__ == "__main__":
#     app.run(debug=True)
