from ldap3 import Server, Connection, ALL
from flask import request, Flask
import os

app = Flask(__name__)


@app.route("/passwordFromEnv")
def passwordFromEnv():
    """
    A RemoteFlowSource is used directly as DN and search filter while the connection's password
    is an environment variable
    """

    dn = request.args['dc']
    search_filter = request.args['search']

    srv = Server('servername', get_info=ALL)
    conn = Connection(srv, user='user_dn',
                      password=os.environ.get('LDAP_PASSWORD'))
    status, result, response, _ = conn.search(dn, search_filter)

# if __name__ == "__main__":
#     app.run(debug=True)
