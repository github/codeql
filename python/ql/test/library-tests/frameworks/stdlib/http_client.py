import sys
import ssl

PY2 = sys.version_info[0] == 2
PY3 = sys.version_info[0] == 3

if PY2:
    from httplib import HTTPConnection, HTTPSConnection
if PY3:
    from http.client import HTTPConnection, HTTPSConnection


# NOTE: the URL may be relative to host, or may be full URL.
conn = HTTPConnection("example.com") # $ clientRequestUrlPart="example.com"
conn.request("GET", "/") # $ clientRequestUrlPart="/"
url = "http://example.com/"
conn.request("GET", url) # $ clientRequestUrlPart=url

# kwargs
conn = HTTPConnection(host="example.com") # $ clientRequestUrlPart="example.com"
conn.request(method="GET", url="/") # $ clientRequestUrlPart="/"

# using internal method... you shouldn't but you can
conn._send_request("GET", "url", body=None, headers={}, encode_chunked=False) # $ clientRequestUrlPart="url"

# low level sending of request
conn.putrequest("GET", "url") # $ clientRequestUrlPart="url"
conn.putheader("X-Foo", "value")
conn.endheaders(message_body=None)

# HTTPS
conn = HTTPSConnection("host") # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url"

# six aliases
import six

conn = six.moves.http_client.HTTPConnection("host") # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url"

conn = six.moves.http_client.HTTPSConnection("host") # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url"

# ==============================================================================
# Certificate validation disabled
# ==============================================================================

# default SSL context is the one given by `_create_default_https_context`
context = ssl._create_default_https_context()
assert context.check_hostname == True
assert context.verify_mode == ssl.CERT_REQUIRED

conn = HTTPSConnection("host", context=context) # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url"

# `_create_default_https_context` is currently just an alias for `create_default_context`
# which creates a context for SERVER_AUTH purpose.
context = ssl.create_default_context()
assert context.check_hostname == True
assert context.verify_mode == ssl.CERT_REQUIRED

conn = HTTPSConnection("host", context=context) # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url"

# however, if you supply your own SSLContext, you need to set it manually
context = ssl.SSLContext()
assert context.check_hostname == False
assert context.verify_mode == ssl.CERT_NONE

conn = HTTPSConnection("host", context=context) # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled

# and if you misunderstood whether to use server/client in the purpose, you will also
# get a context without hostname verification.
context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
assert context.check_hostname == False
assert context.verify_mode == ssl.CERT_NONE

conn = HTTPSConnection("host", context=context) # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled

# NOTICE that current documentation says
#
# > Enabling hostname checking automatically sets verify_mode from CERT_NONE to
# > CERT_REQUIRED. It cannot be set back to CERT_NONE as long as hostname checking is
# > enabled.
# - https://docs.python.org/3.10/library/ssl.html#ssl.SSLContext.check_hostname

context = ssl.SSLContext()
context.check_hostname = True
assert context.verify_mode == ssl.CERT_REQUIRED

conn = HTTPSConnection("host", context=context) # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url"

# only setting verify_mode is not enough, since check_hostname is not enabled

context = ssl.SSLContext()
context.verify_mode = ssl.CERT_REQUIRED
assert context.check_hostname == False

conn = HTTPSConnection("host", context=context) # $ clientRequestUrlPart="host"
conn.request("GET", "url") # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled

# ==============================================================================
# taint test
# ==============================================================================

from flask import request

def taint_test():
    host = request.args['host']
    url = request.args['url']

    conn = HTTPConnection(host) # $ clientRequestUrlPart=host
    conn.request("GET", url) # $ clientRequestUrlPart=url

    resp = conn.getresponse()

    ensure_tainted(
        # see
        # https://docs.python.org/3.10/library/http.client.html#httpresponse-objects
        # https://docs.python.org/3/library/http.client.html#http.client.HTTPResponse

        # a HTTPResponse itself is file-like
        resp, # $ tainted
        resp.read(), # $ tainted

        resp.getheader("name"), # $ tainted
        resp.getheaders(), # $ tainted

        # http.client.HTTPMessage
        resp.headers, # $ tainted
        resp.headers.get_all(), # $ tainted

        # Alias for .headers
        # http.client.HTTPMessage
        resp.msg, # $ tainted
        resp.msg.get_all(), # $ tainted

        # Alias for .headers
        resp.info(), # $ tainted
        resp.info().get_all(), # $ tainted

        # although this would usually be the textual version of the status
        # ("OK" for 200), it is possible to put your own evil data in here.
        resp.reason, # $ tainted

        # the URL of the recourse that was visited, if redirects were followed.
        # I don't see any reason this could not contain evil data.
        resp.url, # $ tainted
        resp.geturl(), # $ tainted
    )

    ensure_not_tainted(
        resp.status,
        resp.code,
        resp.getcode(),
    )

    # check that only setting either host/url is enough to propagate taint
    conn = HTTPConnection("host") # $ clientRequestUrlPart="host"
    conn.request("GET", url) # $ clientRequestUrlPart=url
    resp = conn.getresponse()
    ensure_tainted(resp) # $ tainted

    conn = HTTPConnection(host) # $ clientRequestUrlPart=host
    conn.request("GET", "url") # $ clientRequestUrlPart="url"
    resp = conn.getresponse()
    ensure_tainted(resp) # $ tainted
