from ldap3 import Server, Connection, ALL
from flask import request, Flask
from ldap3.utils.dn import escape_rdn
from ldap3.utils.conv import escape_filter_chars

app = Flask(__name__)


@app.route("/passwordNone")
def passwordNone():
    """
    The bind's password argument is set to None
    """

    dn = "dc={}".format(escape_rdn(request.args['dc']))
    search_filter = "(user={})".format(escape_filter_chars(request.args['search']))

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, 'user_dn', None)
    status, result, response, _ = conn.search(dn, search_filter)


@app.route("/passwordNone")
def passwordNoneKwargs():
    """
    The bind's password argument is set to None
    """

    dn = "dc={}".format(escape_rdn(request.args['dc']))
    search_filter = "(user={})".format(escape_filter_chars(request.args['search']))

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn', password=None)
    status, result, response, _ = conn.search(dn, search_filter)

@app.route("/passwordEmpty")
def passwordEmpty():
    """
    The bind's password argument is an empty string
    """

    dn = "dc={}".format(escape_rdn(request.args['dc']))
    search_filter = "(user={})".format(escape_filter_chars(request.args['search']))

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn', password="")
    status, result, response, _ = conn.search(dn, search_filter)


@app.route("/notPassword")
def notPassword():
    """
    The bind's password argument is not set
    """

    dn = "dc={}".format(escape_rdn(request.args['dc']))
    search_filter = "(user={})".format(escape_filter_chars(request.args['search']))

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn')
    status, result, response, _ = conn.search(dn, search_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
