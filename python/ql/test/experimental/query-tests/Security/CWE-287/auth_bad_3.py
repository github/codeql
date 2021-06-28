from ldap3 import Server, Connection, ALL
from flask import request, Flask

app = Flask(__name__)


@app.route("/passwordNone")
def passwordNone():
    """
    A RemoteFlowSource is used directly as DN and search filter while the connection's password
    is set to None
    """

    dn = request.args['dc']
    search_filter = request.args['search']

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, 'user_dn', None)
    status, result, response, _ = conn.search(dn, search_filter)


@app.route("/passwordNone")
def passwordNoneKwargs():
    """
    A RemoteFlowSource is used directly as DN and search filter while the connection's password
    is set to None
    """

    dn = request.args['dc']
    search_filter = request.args['search']

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn', password=None)
    status, result, response, _ = conn.search(dn, search_filter)

@app.route("/passwordEmpty")
def passwordEmpty():
    """
    A RemoteFlowSource is used directly as DN and search filter while the connection's password
    is empty
    """

    dn = request.args['dc']
    search_filter = request.args['search']

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn', password="")
    status, result, response, _ = conn.search(dn, search_filter)


@app.route("/notPassword")
def notPassword():
    """
    A RemoteFlowSource is used directly as DN and search filter while the connection's password
    is not set
    """

    dn = request.args['dc']
    search_filter = request.args['search']

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn')
    status, result, response, _ = conn.search(dn, search_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
