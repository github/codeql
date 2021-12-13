import requests

from flask import Flask, request

app = Flask(__name__)


@app.route("/taint_test") # $ routeSetup="/taint_test"
def test_taint(): # $ requestHandler
    url = request.args['untrusted_input']

    # response from a request to a user-controlled URL should be considered
    # user-controlled as well.
    resp = requests.get(url) # $ clientRequestUrl=url

    ensure_tainted(
        # see https://docs.python-requests.org/en/latest/api/#requests.Response
        resp, # $ tainted
        resp.text, # $ MISSING: tainted
        resp.content, # $ MISSING: tainted
        resp.json(), # $ MISSING: tainted

        # file-like
        resp.raw, # $ MISSING: tainted

        resp.links, # $ MISSING: tainted
        resp.links['key'], # $ MISSING: tainted
        resp.links.get('key'), # $ MISSING: tainted

        resp.cookies, # $ MISSING: tainted
        resp.cookies['key'], # $ MISSING: tainted
        resp.cookies.get('key'), # $ MISSING: tainted

        resp.headers, # $ MISSING: tainted
        resp.headers['key'], # $ MISSING: tainted
        resp.headers.get('key'), # $ MISSING: tainted
    )

    for content_chunk in resp.iter_content():
        ensure_tainted(content_chunk)  # $ MISSING: tainted

    for line in resp.iter_lines():
        ensure_tainted(line)  # $ MISSING: tainted

    # for now, we don't assume that the response to ANY outgoing request is a remote
    # flow source, since this could lead to FPs.
    # TODO: investigate whether we should consider this a remote flow source.
    trusted_url = "https://internal-api-that-i-trust.com"
    resp = requests.get(trusted_url) # $ clientRequestUrl=trusted_url
    ensure__not_tainted(resp)
