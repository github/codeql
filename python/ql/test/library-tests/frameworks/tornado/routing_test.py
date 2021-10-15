import tornado.web
import tornado.routing


class FooHandler(tornado.web.RequestHandler):
    def get(self, x, y=None, not_used=None):  # $ requestHandler routedParameter=x routedParameter=y
        self.write("FooHandler {} {}".format(x, y)) # $ HttpResponse


class BarHandler(tornado.web.RequestHandler):
    def get(self, x, y=None, not_used=None):  # $ requestHandler routedParameter=x routedParameter=y SPURIOUS: routedParameter=not_used
        self.write("BarHandler {} {}".format(x, y)) # $ HttpResponse


class BazHandler(tornado.web.RequestHandler):
    def get(self, x, y=None, not_used=None):  # $ requestHandler routedParameter=x routedParameter=y SPURIOUS: routedParameter=not_used
        self.write("BazHandler {} {}".format(x, y)) # $ HttpResponse


class KwArgs(tornado.web.RequestHandler):
    def get(self, *, x, y=None, not_used=None):  # $ requestHandler routedParameter=x routedParameter=y
        self.write("KwArgs {} {}".format(x, y)) # $ HttpResponse


class OnlyLocalhost(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        self.write("OnlyLocalhost") # $ HttpResponse


class One(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        self.write("One") # $ HttpResponse


class Two(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        self.write("Two") # $ HttpResponse


class Three(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        self.write("Three") # $ HttpResponse


class AddedLater(tornado.web.RequestHandler):
    def get(self, x, y=None, not_used=None):  # $ requestHandler routedParameter=x routedParameter=y
        self.write("AddedLater {} {}".format(x, y)) # $ HttpResponse


class PossiblyNotRouted(tornado.web.RequestHandler):
    # Even if our analysis can't find a route-setup for this class, we should still
    # consider it to be a handle incoming HTTP requests

    def get(self):  # $ requestHandler
        self.write("NotRouted") # $ HttpResponse


def make_app():
    # see https://www.tornadoweb.org/en/stable/routing.html for even more examples
    app = tornado.web.Application(
        [
            (r"/foo/([0-9]+)/([0-9]+)?", FooHandler),  # $ routeSetup="/foo/([0-9]+)/([0-9]+)?"
            tornado.web.URLSpec(r"/bar/([0-9]+)/([0-9]+)?", BarHandler),  # $ MISSING: routeSetup="/bar/([0-9]+)/([0-9]+)?"
            # Very verbose way to write same as FooHandler
            tornado.routing.Rule(tornado.routing.PathMatches(r"/baz/([0-9]+)/([0-9]+)?"), BazHandler),  # $ MISSING: routeSetup="/baz/([0-9]+)/([0-9]+)?"
            (r"/kw-args/(?P<x>[0-9]+)/(?P<y>[0-9]+)?", KwArgs),  # $ routeSetup="/kw-args/(?P<x>[0-9]+)/(?P<y>[0-9]+)?"
            # You can do nesting
            (r"/(one|two|three)", [
                (r"/one", One),  # $ routeSetup="/one"
                (r"/two", Two),  # $ routeSetup="/two"
                (r"/three", Three)  # $ routeSetup="/three"
            ]),
            # which is _one_ recommended way to ensure known host is used
            (tornado.routing.HostMatches(r"(localhost|127\.0\.0\.1)"), [
                ("/only-localhost", OnlyLocalhost)  # $ routeSetup="/only-localhost"
            ]),

        ],
        debug=True,
    )
    app.add_handlers(r".*", [(r"/added-later/([0-9]+)/([0-9]+)?", AddedLater)])  # $ routeSetup="/added-later/([0-9]+)/([0-9]+)?"
    return app


if __name__ == "__main__":

    import tornado.ioloop
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

    # http://localhost:8888/foo/42/
    # http://localhost:8888/foo/42/1337

    # http://localhost:8888/bar/42/
    # http://localhost:8888/bar/42/1337

    # http://localhost:8888/baz/42/
    # http://localhost:8888/baz/42/1337

    # http://localhost:8888/kw-args/42/
    # http://localhost:8888/kw-args/42/1337

    # http://localhost:8888/only-localhost

    # http://localhost:8888/one
    # http://localhost:8888/two
    # http://localhost:8888/three

    # http://localhost:8888/added-later
