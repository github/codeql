from twisted.web.server import Site, Request, NOT_DONE_YET
from twisted.web.resource import Resource
from twisted.internet import reactor, endpoints, defer


root = Resource()

class Now(Resource):
    def render(self, request: Request): # $ requestHandler
        return b"now" # $ HttpResponse mimetype=text/html responseBody=b"now"


class AlsoNow(Resource):
    def render(self, request: Request): # $ requestHandler
        request.write(b"also now") # $ HttpResponse mimetype=text/html responseBody=b"also now"
        return b"" # $ HttpResponse mimetype=text/html responseBody=b""


def process_later(request: Request):
    print("process_later called")
    request.write(b"later") # $ MISSING: responseBody=b"later"
    request.finish()


class Later(Resource):
    def render(self, request: Request): # $ requestHandler
        # process the request in 1 second
        print("setting up callback for process_later")
        reactor.callLater(1, process_later, request)
        return NOT_DONE_YET # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=NOT_DONE_YET


class PlainText(Resource):
    def render(self, request: Request): # $ requestHandler
        request.setHeader(b"content-type", "text/plain")
        return b"this is plain text" # $ HttpResponse responseBody=b"this is plain text" SPURIOUS: mimetype=text/html MISSING: mimetype=text/plain


class Redirect(Resource):
    def render_GET(self, request: Request): # $ requestHandler
        request.redirect("/new-location") # $ HttpRedirectResponse redirectLocation="/new-location" HttpResponse mimetype=text/html
        # By default, this `hello` output is not returned... not even when
        # requested with curl.
        return b"hello" # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=b"hello"

################################################################################
# Cookies
################################################################################

class CookieWriting(Resource):
    """Examples of providing values in response that is not in the body
    """
    def render_GET(self, request: Request): # $ requestHandler
        request.addCookie("key", "value") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
        request.addCookie(k="key", v="value") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
        request.addCookie("key", "value", secure=True, httponly=True, samesite="strict") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=true CookieHttpOnly=true CookieSameSite=Strict
        val = "key2=value"
        request.cookies.append(val) # $ CookieWrite CookieRawHeader=val CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax

        request.responseHeaders.addRawHeader("key", "value")
        request.setHeader("Set-Cookie", "key3=value3") # $ MISSING: CookieWrite CookieRawHeader="key3=value3" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax

        return b"" # $ HttpResponse mimetype=text/html responseBody=b""


root.putChild(b"now", Now())
root.putChild(b"also-now", AlsoNow())
root.putChild(b"later", Later())
root.putChild(b"plain-text", PlainText())
root.putChild(b"redirect", Redirect())
root.putChild(b"setting_cookie", CookieWriting())


if __name__ == "__main__":
    factory = Site(root)
    endpoint = endpoints.TCP4ServerEndpoint(reactor, 8880)
    endpoint.listen(factory)

    print("Will run on http://localhost:8880")

    reactor.run()
