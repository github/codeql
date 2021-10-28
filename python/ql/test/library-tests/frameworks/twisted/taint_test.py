from twisted.web.resource import Resource
from twisted.web.server import Request

class MyTaintTest(Resource):
    def getChild(self, path, request): # $ requestHandler
        ensure_tainted(path, request) # $ tainted

    def render(self, request): # $ requestHandler
        ensure_tainted(request) # $ tainted

    def render_GET(self, request: Request): # $ requestHandler
        # see https://twistedmatrix.com/documents/21.2.0/api/twisted.web.server.Request.html
        ensure_tainted(
            request, # $ tainted

            request.uri, # $ tainted
            request.path, # $ tainted
            request.prepath, # $ tainted
            request.postpath, # $ tainted

            # file-like
            request.content, # $ tainted
            request.content.read(), # $ MISSING: tainted

            # Dict[bytes, List[bytes]] (for query args)
            request.args, # $ tainted
            request.args[b"key"], # $ tainted
            request.args[b"key"][0], # $ tainted
            request.args.get(b"key"), # $ tainted
            request.args.get(b"key")[0], # $ tainted

            request.received_cookies, # $ tainted
            request.received_cookies["key"], # $ tainted
            request.received_cookies.get("key"), # $ tainted
            request.getCookie(b"key"), # $ tainted

            # twisted.web.http_headers.Headers
            # see https://twistedmatrix.com/documents/21.2.0/api/twisted.web.http_headers.Headers.html
            request.requestHeaders, # $ tainted
            request.requestHeaders.getRawHeaders("key"), # $ MISSING: tainted
            request.requestHeaders.getRawHeaders("key")[0], # $ MISSING: tainted
            request.requestHeaders.getAllRawHeaders(), # $ MISSING: tainted
            list(request.requestHeaders.getAllRawHeaders()), # $ MISSING: tainted

            request.getHeader("key"), # $ tainted
            request.getAllHeaders(), # $ tainted
            request.getAllHeaders()["key"], # $ tainted

            request.user, # $ tainted
            request.getUser(), # $ tainted

            request.password, # $ tainted
            request.getPassword(), # $ tainted

            request.host, # $ tainted
            request.getHost(), # $ tainted
            request.getRequestHostname(), # $ tainted
        )

        # technically user-controlled, but unlikely to lead to vulnerabilities.
        ensure_not_tainted(
            request.method,
        )

        # not tainted at all
        ensure_not_tainted(
            # outgoing things
            request.cookies,
            request.responseHeaders,
        )
