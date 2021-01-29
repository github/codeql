import tornado.web


class TaintTest(tornado.web.RequestHandler):
    def get(self, name = "World!", number="0", foo="foo"):  # $ requestHandler routedParameter=name routedParameter=number
        ensure_tainted(name, number)
        ensure_not_tainted(foo)

        ensure_tainted(
            # see https://www.tornadoweb.org/en/stable/web.html#input
            self.get_argument("name"),
            self.get_arguments("name"),
            self.get_arguments("name")[0],

            self.get_body_argument("name"),
            self.get_body_arguments("name"),
            self.get_body_arguments("name")[0],

            self.get_query_argument("name"),
            self.get_query_arguments("name"),
            self.get_query_arguments("name")[0],

            self.path_args,
            self.path_args[0],

            self.path_kwargs,
            self.path_kwargs["name"],
        )

        request = self.request

        ensure_tainted(
            # see https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPServerRequest
            request,

            request.uri,
            request.path,
            request.query,
            request.full_url(),

            request.remote_ip,

            request.body,

            request.arguments,
            request.arguments["name"],
            request.arguments["name"][0],

            request.query_arguments,
            request.query_arguments["name"],
            request.query_arguments["name"][0],

            request.body_arguments,
            request.body_arguments["name"],
            request.body_arguments["name"][0],

            # dict-like, see https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPHeaders
            request.headers,
            request.headers["header-name"],
            request.headers.get_list("header-name"),
            request.headers.get_all(),
            [(k, v) for (k, v) in request.headers.get_all()],

            # Dict[str, http.cookies.Morsel]
            request.cookies,
            request.cookies["cookie-name"],
            request.cookies["cookie-name"].key,
            request.cookies["cookie-name"].value,
        )


def make_app():
    return tornado.web.Application(
        [
            (r"/test_taint/([^/]+)/([0-9]+)", TaintTest),  # $ routeSetup="/test_taint/([^/]+)/([0-9]+)"
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
