from http.server import BaseHTTPRequestHandler, SimpleHTTPRequestHandler
import http.server


def constructors(request, address, server, headers):
    SimpleHTTPRequestHandler(request, address, server, extra_response_headers=headers) # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value
    http.server.SimpleHTTPRequestHandler(request, address, server, extra_response_headers=headers) # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value
    handler = SimpleHTTPRequestHandler
    handler(request, address, server, extra_response_headers=headers) # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value

    SimpleHTTPRequestHandler(request, address, server, extra_response_headers=[("X-Example", "value")]) # $ headerWriteBulk=List headerWriteBulkUnsanitized=name,value headerWriteNameUnsanitized="X-Example" headerWriteValueUnsanitized="value"
    SimpleHTTPRequestHandler(request, address, server)


class CustomHandler(SimpleHTTPRequestHandler):
    def change_headers(self, headers):
        self.extra_response_headers = headers # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value
        alias = self
        alias.extra_response_headers = [("X-Alias", "value")] # $ headerWriteBulk=List headerWriteBulkUnsanitized=name,value headerWriteNameUnsanitized="X-Alias" headerWriteValueUnsanitized="value"
        ensure_tainted(alias.headers) # $ tainted
        ensure_not_tainted(alias.extra_response_headers)

    def delegate(self, headers):
        write_simple_headers(self, headers)


class DerivedHandler(CustomHandler):
    def change_again(self, headers):
        self.extra_response_headers = headers # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value


def constructed_instance(request, address, server, headers):
    handler = SimpleHTTPRequestHandler(request, address, server)
    handler.extra_response_headers = headers # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value
    write_simple_headers(handler, headers)


def write_simple_headers(handler, headers):
    alias = handler
    alias.extra_response_headers = headers # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value


def annotated_instance(handler: SimpleHTTPRequestHandler, headers):
    handler.extra_response_headers = headers # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value


class InheritedInitHandler(SimpleHTTPRequestHandler):
    pass


def inherited_constructor(request, address, server, headers):
    InheritedInitHandler(request, address, server, extra_response_headers=headers) # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value


class BaseOnlyHandler(BaseHTTPRequestHandler):
    def change_headers(self, headers):
        # BaseHTTPRequestHandler does not consume this attribute.
        self.extra_response_headers = headers
        write_base_headers(self, headers)


def write_base_headers(handler, headers):
    alias = handler
    alias.extra_response_headers = headers


class Unrelated:
    def __init__(self, *, extra_response_headers):
        self.extra_response_headers = extra_response_headers


def unrelated(headers):
    Unrelated(extra_response_headers=headers)
