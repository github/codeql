from twisted.web.server import Site, Request, NOT_DONE_YET
from twisted.web.resource import Resource
from twisted.internet import reactor, endpoints, defer


root = Resource()

class Now(Resource):
    def render(self, request: Request):
        return b"now"


class AlsoNow(Resource):
    def render(self, request: Request):
        request.write(b"also now")
        return b""


def process_later(request: Request):
    print("process_later called")
    request.write(b"later")
    request.finish()


class Later(Resource):
    def render(self, request: Request):
        # process the request in 1 second
        print("setting up callback for process_later")
        reactor.callLater(1, process_later, request)
        return NOT_DONE_YET


class PlainText(Resource):
    def render(self, request: Request):
        request.setHeader(b"content-type", "text/plain")
        return b"this is plain text"


class Redirect(Resource):
    def render_GET(self, request: Request):
        request.redirect("/new-location")
        # By default, this `hello` output is not returned... not even when
        # requested with curl.
        return b"hello"


class NonHttpBodyOutput(Resource):
    """Examples of provides values in response that is not in the body
    """
    def render_GET(self, request: Request):
        request.responseHeaders.addRawHeader("key", "value")
        request.setHeader("key2", "value")

        request.addCookie("key", "value")
        request.cookies.append(b"key2=value")

        return b""


root.putChild(b"now", Now())
root.putChild(b"also-now", AlsoNow())
root.putChild(b"later", Later())
root.putChild(b"plain-text", PlainText())
root.putChild(b"redirect", Redirect())
root.putChild(b"non-body", NonHttpBodyOutput())


if __name__ == "__main__":
    factory = Site(root)
    endpoint = endpoints.TCP4ServerEndpoint(reactor, 8880)
    endpoint.listen(factory)

    print("Will run on http://localhost:8880")

    reactor.run()
