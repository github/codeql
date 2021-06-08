from twisted.web.resource import Resource
from twisted.web.server import Request

class MyTaintTest(Resource):
    def getChild(self, path, request):
        ensure_tainted(path, request) # $ MISSING: tainted

    def render(self, request):
        ensure_tainted(request) # $ MISSING: tainted

    def render_GET(self, request: Request):
        # see https://twistedmatrix.com/documents/21.2.0/api/twisted.web.server.Request.html
        ensure_tainted(
            request, # $ MISSING: tainted

            request.uri, # $ MISSING: tainted
            request.path, # $ MISSING: tainted
            request.prepath, # $ MISSING: tainted
            request.postpath, # $ MISSING: tainted

            # file-like
            request.content, # $ MISSING: tainted
            request.content.read(), # $ MISSING: tainted

            # Dict[bytes, List[bytes]] (for query args)
            request.args, # $ MISSING: tainted
            request.args[b"key"], # $ MISSING: tainted
            request.args[b"key"][0], # $ MISSING: tainted
            request.args.get(b"key"), # $ MISSING: tainted
            request.args.get(b"key")[0], # $ MISSING: tainted

            request.received_cookies, # $ MISSING: tainted
            request.received_cookies["key"], # $ MISSING: tainted
            request.received_cookies.get("key"), # $ MISSING: tainted
            request.getCookie(b"key"), # $ MISSING: tainted

            # twisted.web.http_headers.Headers
            # see https://twistedmatrix.com/documents/21.2.0/api/twisted.web.http_headers.Headers.html
            request.requestHeaders, # $ MISSING: tainted
            request.requestHeaders.getRawHeaders("key"), # $ MISSING: tainted
            request.requestHeaders.getRawHeaders("key")[0], # $ MISSING: tainted
            request.requestHeaders.getAllRawHeaders(), # $ MISSING: tainted
            list(request.requestHeaders.getAllRawHeaders()), # $ MISSING: tainted

            request.getHeader("key"), # $ MISSING: tainted
            request.getAllHeaders(), # $ MISSING: tainted
            request.getAllHeaders()["key"], # $ MISSING: tainted

            request.user, # $ MISSING: tainted
            request.getUser(), # $ MISSING: tainted

            request.password, # $ MISSING: tainted
            request.getPassword(), # $ MISSING: tainted

            request.host, # $ MISSING: tainted
            request.getHost(), # $ MISSING: tainted
            request.getRequestHostname(), # $ MISSING: tainted
        )

        # technically user-controlled, but unlike to lead to vulnerabilities.
        ensure_not_tainted(
            request.method,
        )

        # not tainted at all
        ensure_not_tainted(
            # outgoing things
            request.cookies,
            request.responseHeaders,
        )
