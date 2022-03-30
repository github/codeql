import tornado.web
import tornado.httputil


class ResponseWriting(tornado.web.RequestHandler):
    def get(self, type_):  # $ requestHandler routedParameter=type_
        if type_ == "str":
            self.write("foo") # $ HttpResponse mimetype=text/html responseBody="foo"
        elif type_ == "bytes":
            self.write(b"foo") # $ HttpResponse mimetype=text/html responseBody=b"foo"
        elif type_ == "dict":
            d = {"foo": 42}
            # Content-type will be set to `application/json`
            self.write(d) # $ HttpResponse responseBody=d MISSING: mimetype=application/json SPURIOUS: mimetype=text/html
        else:
            raise Exception("Bad type {} {}".format(type_, type(type_)))


class ExplicitContentType(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        # Note: Our current modeling makes it quite hard to give a good annotation here
        # this write is technically while the HTTP response has mimetype text/html, but
        # the returned HTTP response will have mimetype text/plain, which is _really_
        # what matters.

        self.write("foo") # $ HttpResponse mimetype=text/html responseBody="foo"
        self.set_header("Content-Type", "text/plain; charset=utf-8")

    def post(self): # $ requestHandler
        self.set_header("Content-Type", "text/plain; charset=utf-8")
        self.write("foo") # $ HttpResponse responseBody="foo" MISSING: mimetype=text/plain SPURIOUS: mimetype=text/html


class ExampleRedirect(tornado.web.RequestHandler):
    def get(self): # $ requestHandler
        url = "http://example.com"
        self.redirect(url) # $ HttpRedirectResponse HttpResponse redirectLocation=url


class ExampleConnectionWrite(tornado.web.RequestHandler):
    def get(self, stream=False): # $ requestHandler routedParameter=stream

        if not stream:
            self.request.connection.write_headers(
                tornado.httputil.ResponseStartLine('', 200, 'OK'),
                tornado.httputil.HTTPHeaders(),
            )
            self.request.connection.write(b"foo") # $ MISSING: HttpResponse responseBody=b"foo"
            self.request.connection.finish()
        else:
            # Note: The documentation says that connection.detach(): "May only be called
            # during HTTPMessageDelegate.headers_received". Doing it here actually
            # works, but does make tornado spit out some errors... good enough to
            # illustrate the behavior.
            #
            # https://www.tornadoweb.org/en/stable/http1connection.html#tornado.http1connection.HTTP1Connection.detach
            stream = self.request.connection.detach()
            stream.write(b"foo stream") # $ MISSING: HttpResponse responseBody=b"foo stream"
            stream.close()

################################################################################
# Cookies
################################################################################

class CookieWriting(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        self.write("foo") # $ HttpResponse mimetype=text/html responseBody="foo"
        self.set_cookie("key", "value") # $ CookieWrite CookieName="key" CookieValue="value"
        self.set_cookie(name="key", value="value") # $ CookieWrite CookieName="key" CookieValue="value"
        self.set_header("Set-Cookie", "key2=value2") # $ MISSING: CookieWrite CookieRawHeader="key2=value2"


def make_app():
    return tornado.web.Application(
        [
            (r"/ResponseWriting/(str|bytes|dict)", ResponseWriting),  # $ routeSetup="/ResponseWriting/(str|bytes|dict)"
            (r"/ExplicitContentType", ExplicitContentType), # $ routeSetup="/ExplicitContentType"
            (r"/ExampleRedirect", ExampleRedirect), # $ routeSetup="/ExampleRedirect"
            (r"/ExampleConnectionWrite", ExampleConnectionWrite), # $ routeSetup="/ExampleConnectionWrite"
            (r"/ExampleConnectionWrite/(stream)", ExampleConnectionWrite), # $ routeSetup="/ExampleConnectionWrite/(stream)"
            (r"/CookieWriting", CookieWriting), # $ routeSetup="/CookieWriting"
        ],
        debug=True,
    )


if __name__ == "__main__":
    import tornado.ioloop

    print("running on http://localhost:8888/")
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

    # http://localhost:8888/ResponseWriting/str
    # http://localhost:8888/ResponseWriting/bytes
    # http://localhost:8888/ResponseWriting/dict
    # http://localhost:8888/ExplicitContentType
    # http://localhost:8888/ExampleRedirect
    # http://localhost:8888/ExampleConnectionWrite
