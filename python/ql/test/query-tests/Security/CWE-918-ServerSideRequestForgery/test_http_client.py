from flask import request # $ Source
from flask import Flask
from http.client import HTTPConnection

app = Flask(__name__)

@app.route("/ssrf_test") # $ routeSetup="/ssrf_test"
def ssrf_test():
    unsafe_host = request.args["host"]
    unsafe_path = request.args["path"]
    user_input = request.args['untrusted_input']

    conn = HTTPConnection(unsafe_host) # $ Sink[py/full-ssrf]
    # NOT OK -- user has full control
    conn.request("GET", unsafe_path) # $ Alert[py/full-ssrf]

    # Full SSRF variant, where there is also a request with fixed URL on the same
    # connection later on. This should not change anything on the overall SSRF alerts.
    conn = HTTPConnection(unsafe_host) # $ Sink
    # NOT OK -- user has full control
    conn.request("GET", unsafe_path) # $ Alert[py/full-ssrf]

    # partial SSRF on SAME connection
    # NOT OK -- user has control of host
    conn.request("GET", "/foo") # $ Alert[py/partial-ssrf]

    # the rest are partial SSRF
    conn = HTTPConnection(unsafe_host) # $ Sink[py/partial-ssrf]
     # NOT OK -- user controlled domain
    conn.request("GET", "/foo") # $ Alert[py/partial-ssrf]

    conn = HTTPConnection("example.com")
    # NOT OK -- user controlled path
    conn.request("GET", unsafe_path) # $ Alert[py/partial-ssrf]

    path = "foo?" + user_input
    conn = HTTPConnection("example.com")
    # NOT OK -- user controlled query parameters
    conn.request("GET", path) # $ Alert[py/partial-ssrf]

    path = "foo#" + user_input
    conn = HTTPConnection("example.com")
    # NOT OK -- user controlled fragment
    conn.request("GET", path) # $ Alert[py/partial-ssrf]