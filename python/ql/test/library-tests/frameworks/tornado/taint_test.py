import tornado.web


class TaintTest(tornado.web.RequestHandler):
    def get(self, name = "World!", number="0", foo="foo"):  # $ requestHandler routedParameter=name routedParameter=number
        ensure_tainted(name, number) # $ tainted
        ensure_not_tainted(foo)

        ensure_tainted(
            # see https://www.tornadoweb.org/en/stable/web.html#input
            self.get_argument("name"), # $ tainted
            self.get_arguments("name"), # $ tainted
            self.get_arguments("name")[0], # $ tainted

            self.get_body_argument("name"), # $ tainted
            self.get_body_arguments("name"), # $ tainted
            self.get_body_arguments("name")[0], # $ tainted

            self.get_query_argument("name"), # $ tainted
            self.get_query_arguments("name"), # $ tainted
            self.get_query_arguments("name")[0], # $ tainted

            self.path_args, # $ tainted
            self.path_args[0], # $ tainted

            self.path_kwargs, # $ tainted
            self.path_kwargs["name"], # $ tainted
        )

        request = self.request

        ensure_tainted(
            # see https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPServerRequest
            request, # $ tainted

            # For the URL https:://example.com/foo/bar?baz=42
            # request.uri="/foo/bar?baz=42"
            # request.path="/foo/bar"
            # request.query="baz=42"
            request.uri, # $ tainted
            request.path, # $ tainted
            request.query, # $ tainted
            request.full_url(), # $ tainted

            request.remote_ip, # $ tainted

            request.body, # $ tainted

            request.arguments, # $ tainted
            request.arguments["name"], # $ tainted
            request.arguments["name"][0], # $ tainted

            request.query_arguments, # $ tainted
            request.query_arguments["name"], # $ tainted
            request.query_arguments["name"][0], # $ tainted

            request.body_arguments, # $ tainted
            request.body_arguments["name"], # $ tainted
            request.body_arguments["name"][0], # $ tainted

            # dict-like, see https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPHeaders
            request.headers, # $ tainted
            request.headers["header-name"], # $ tainted
            request.headers.get_list("header-name"), # $ tainted
            request.headers.get_all(), # $ tainted
            [(k, v) for (k, v) in request.headers.get_all()], # $ tainted

            # Dict[str, http.cookies.Morsel]
            request.cookies, # $ tainted
            request.cookies["cookie-name"], # $ tainted
            request.cookies["cookie-name"].key, # $ tainted
            request.cookies["cookie-name"].value, # $ tainted
            request.cookies["cookie-name"].coded_value, # $ tainted
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
