from http.server import BaseHTTPRequestHandler, SimpleHTTPRequestHandler


class ExtraHeadersHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        name = self.headers["X-Header-Name"]
        value = self.headers["X-Header-Value"]

        self.extra_response_headers = [("X-Value", value)] # BAD
        alias = self
        alias.extra_response_headers = [(name, "value")] # BAD

        clean_name = name.replace("\r", "").replace("\n", "")
        clean_value = value.replace("\r", "").replace("\n", "")
        self.extra_response_headers = [(clean_name, clean_value)] # GOOD
        self.extra_response_headers = [("X-Static", "value")] # GOOD
        super().do_GET()


class DispatchHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        name = self.headers["X-Header-Name"]
        value = self.headers["X-Header-Value"]

        SimpleHTTPRequestHandler(
            self.request, self.client_address, self.server,
            extra_response_headers=[("X-Value", value)], # BAD
        )
        # BaseHTTPRequestHandler does not consume this attribute.
        self.extra_response_headers = [(name, value)] # GOOD
