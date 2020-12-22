import tornado.web


class ResponseWriting(tornado.web.RequestHandler):
    def get(self, type_):  # $ requestHandler routedParameter=type_
        if type_ == "str":
            self.write("foo")
        elif type_ == "bytes":
            self.write(b"foo")
        elif type_ == "dict":
            # Content-type will be set to `application/json`
            self.write({"foo": 42})
        else:
            raise Exception("Bad type {} {}".format(type_, type(type_)))


def make_app():
    return tornado.web.Application(
        [
            (r"/ResponseWriting/(str|bytes|dict)", ResponseWriting),  # $ routeSetup="/ResponseWriting/(str|bytes|dict)"
        ],
        debug=True,
    )


if __name__ == "__main__":
    import tornado.ioloop

    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

    # http://localhost:8888/ResponseWriting/str
    # http://localhost:8888/ResponseWriting/bytes
    # http://localhost:8888/ResponseWriting/dict
