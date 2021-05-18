from django.conf.urls import url
from clickhouse_driver import Client
from clickhouse_driver import connect
from aioch import Client as aiochClient

# Dummy Client subclass
class MyClient(Client):
    def dummy(self):
        return None

def show_user(request, username):

    # BAD -- Untrusted user input is directly injected into the sql query using async library 'aioch'
    aclient = aiochClient("localhost")
    progress = await aclient.execute_with_progress("SELECT * FROM users WHERE username = '%s'" % username)

    # BAD -- Untrusted user input is directly injected into the sql query using native client of library 'clickhouse_driver'
    Client('localhost').execute("SELECT * FROM users WHERE username = '%s'" % username)

    # GOOD -- query uses prepared statements
    query = "SELECT * FROM users WHERE username = %(username)s"
    Client('localhost').execute(query, {"username": username})

    # BAD -- Untrusted user input is directly injected into the sql query using PEP249 interface
    conn = connect('clickhouse://localhost')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = '%s'" % username)

    # BAD -- Untrusted user input is directly injected into the sql query using MyClient, which is a subclass of Client
    MyClient('localhost').execute("SELECT * FROM users WHERE username = '%s'" % username)

urlpatterns = [url(r'^users/(?P<username>[^/]+)$', show_user)]
