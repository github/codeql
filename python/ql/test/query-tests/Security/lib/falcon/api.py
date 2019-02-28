
"""Falcon API class."""

class API(object):

    def add_route(self, uri_template, resource, **kwargs):
        pass

    def add_sink(self, sink, prefix=r'/'):
        pass

    def add_error_handler(self, exception, handler=None):
        pass

