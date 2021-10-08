from ldap3 import Server, Connection, ALL
from flask import request, Flask

app = Flask(__name__)

schema = "ldap://"
partial_host = "127.0.0.1"
full_host = "ldap://127.0.0.1"


# hardcoded host

@app.route("/one")
def one():
    srv = Server("ldap://127.0.0.1", port=1337)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# host from variable

@app.route("/two")
def two():
    srv = Server(full_host, port=1337)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# schema from string + variable

@app.route("/three")
def three():
    host = "ldap://" + partial_host

    srv = Server(host, port=1337)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# schema from variable + variable

@app.route("/four")
def four():
    host = schema + partial_host

    srv = Server(host, port=1337)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# schema from string + string

@app.route("/five")
def five():
    host = "ldap://" + "127.0.0.1"

    srv = Server(host, port=1337)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# schema from variable + hardcoded host

@app.route("/six")
def six():
    host = schema + "127.0.0.1"

    srv = Server(host, port=1337)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (positional argument)
# host from string + variable

@app.route("/four")
def four():
    host = "ldap://" + partial_host

    srv = Server(host, 1337, True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")
    return conn.response


# use_ssl = True (argument by name)
# host from variable + variable

@app.route("/five")
def five():
    host = schema + partial_host

    srv = Server(host, port=1337, use_ssl=True)
    conn = Connection(srv, "dn", "password")
    conn.search("dn", "search_filter")


# if __name__ == "__main__":
#     app.run(debug=True)
