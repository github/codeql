from flask import Flask, request

from http.client import HTTPConnection

app = Flask(__name__)

@app.route("/ssrf_test") # $ routeSetup="/ssrf_test"
def ssrf_test():
    unsafe_host = request.args["host"]
    unsafe_path = request.args["path"]
    user_input = request.args['untrusted_input']

    conn = HTTPConnection(unsafe_host)
    conn.request("GET", unsafe_path) # NOT OK -- user has full control

    # Full SSRF variant, where there is ALSO made a request with fixed URL on the same
    # connection later on. This should not change anything on the overall SSRF alerts.
    conn = HTTPConnection(unsafe_host)
    conn.request("GET", unsafe_path) # NOT OK -- user has full control

    # partial SSRF on SAME connection
    conn.request("GET", "/foo") # NOT OK -- user has control of host

    # the rest are partial SSRF
    conn = HTTPConnection(unsafe_host)
    conn.request("GET", "/foo") # NOT OK -- user controlled domain

    conn = HTTPConnection("example.com")
    conn.request("GET", unsafe_path) # NOT OK -- user controlled path

    path = "foo?" + user_input
    conn = HTTPConnection("example.com")
    conn.request("GET", path) # NOT OK -- user controlled query parameters

    path = "foo#" + user_input
    conn = HTTPConnection("example.com")
    conn.request("GET", path) # NOT OK -- user controlled fragment
