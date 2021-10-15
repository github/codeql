from ldap3 import Server, Connection, ALL
from flask import request, Flask

app = Flask(__name__)

schema = "ldap://"
remote_host = "somethingon.theinternet.com"
full_host = "ldap://somethingon.theinternet.com"


# use_ssl = True (positional argument)
# hardcoded host

@app.route("/one")
def one():
    srv = Server("ldap://somethingon.theinternet.com", 1337, True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (argument by name)
# host from variable

@app.route("/two")
def two():
    srv = Server(full_host, port=1337, use_ssl=True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (argument by name)
# host from RFS

@app.route("/three")
def three():
    srv = Server(request.args['host'], port=1337, use_ssl=True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (positional argument)
# host from string + variable

@app.route("/four")
def four():
    host = "ldap://" + remote_host

    srv = Server(host, 1337, True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (argument by name)
# host from variable + variable

@app.route("/five")
def five():
    host = schema + remote_host

    srv = Server(host, port=1337, use_ssl=True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (argument by name)
# host from string + RFS

@app.route("/six")
def six():
    host = "ldap://" + request.args['host']

    srv = Server(host, port=1337, use_ssl=True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (positional argument)
# host from variable + RFS

@app.route("/seven")
def seven():
    host = schema + request.args['host']

    srv = Server(host, 1337, True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# SSL through special method
# host from variable + hardcoded host

@app.route("/eight")
def eight():
    host = schema + "somethingon.theinternet.com"
    srv = Server(host, port=1337)
    conn = Connection(srv, "dn", "password")
    conn.start_tls()
    conn.search("dn", "search_filter")
    return conn.response


# No SSL (to test sink)
# host from variable + hardcoded host

@app.route("/nine")
def nine():
    host = schema + "somethingon.theinternet.com"
    srv = Server(host, 1337, False)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# No SSL (to test sink)
# host from variable + variable

@app.route("/ten")
def ten():
    host = schema + remote_host
    srv = Server(host, port=1337, use_ssl=False)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# No SSL (to test sink)
# host from variable + RFS

@app.route("/eleven")
def eleven():
    host = schema + request.args['host']
    srv = Server(host, port=1337)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# if __name__ == "__main__":
#     app.run(debug=True)
