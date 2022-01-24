import tornado.web


class BasicHandler(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        self.write("BasicHandler " + self.get_argument("xss")) # $ HttpResponse

    def post(self):  # $ requestHandler
        self.write("BasicHandler (POST)") # $ HttpResponse


class DeepInheritance(BasicHandler):
    def get(self):  # $ requestHandler
        self.write("DeepInheritance" + self.get_argument("also_xss")) # $ HttpResponse


class FormHandler(tornado.web.RequestHandler):
    def post(self):  # $ requestHandler
        name = self.get_body_argument("name")
        self.write(name) # $ HttpResponse


class RedirectHandler(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        req = self.request
        h = req.headers
        url = h["url"]
        self.redirect(url) # $ HttpRedirectResponse HttpResponse redirectLocation=url


class BaseReverseInheritance(tornado.web.RequestHandler):
    def get(self):  # $ requestHandler
        self.write("hello from BaseReverseInheritance") # $ HttpResponse


class ReverseInheritance(BaseReverseInheritance):
    pass


def make_app():
    return tornado.web.Application(
        [
            (r"/basic", BasicHandler),  # $ routeSetup="/basic"
            (r"/deep", DeepInheritance),  # $ routeSetup="/deep"
            (r"/form", FormHandler),  # $ routeSetup="/form"
            (r"/redirect", RedirectHandler),  # $ routeSetup="/redirect"
            (r"/reverse-inheritance", ReverseInheritance),  # $ routeSetup="/reverse-inheritance"
        ],
        debug=True,
    )


if __name__ == "__main__":
    import tornado.ioloop

    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

    # http://localhost:8888/basic?xss=foo
    # http://localhost:8888/deep?also_xss=foo

    # curl -X POST http://localhost:8888/basic
    # curl -X POST http://localhost:8888/deep

    # curl -X POST -F "name=foo" http://localhost:8888/form
    # curl -v -H 'url: http://example.com' http://localhost:8888/redirect

    # http://localhost:8888/reverse-inheritance
