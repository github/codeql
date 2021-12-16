import requests

from flask import Flask, request

app = Flask(__name__)


@app.route("/taint_test") # $ routeSetup="/taint_test"
def test_taint(): # $ requestHandler
    url = request.args['untrusted_input']

    # response from a request to a user-controlled URL should be considered
    # user-controlled as well.
    resp = requests.get(url) # $ clientRequestUrlPart=url

    requests.Response
    requests.models.Response

    ensure_tainted(
        url, # $ tainted
        # see https://docs.python-requests.org/en/latest/api/#requests.Response
        resp, # $ tainted
        resp.text, # $ tainted
        resp.content, # $ tainted
        resp.json(), # $ tainted

        # file-like
        resp.raw, # $ tainted
        resp.raw.read(), # $ tainted

        resp.links, # $ tainted
        resp.links['key'], # $ tainted
        resp.links.get('key'), # $ tainted

        resp.cookies, # $ tainted
        resp.cookies['key'], # $ tainted
        resp.cookies.get('key'), # $ tainted

        resp.headers, # $ tainted
        resp.headers['key'], # $ tainted
        resp.headers.get('key'), # $ tainted
    )

    for content_chunk in resp.iter_content():
        ensure_tainted(content_chunk)  # $ tainted

    for line in resp.iter_lines():
        ensure_tainted(line)  # $ tainted

    # for now, we don't assume that the response to ANY outgoing request is a remote
    # flow source, since this could lead to FPs.
    # TODO: investigate whether we should consider this a remote flow source.
    trusted_url = "https://internal-api-that-i-trust.com"
    resp = requests.get(trusted_url) # $ clientRequestUrlPart=trusted_url
    ensure__not_tainted(resp)
