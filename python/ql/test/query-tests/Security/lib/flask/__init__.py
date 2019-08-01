

class Flask(object): 
    def run(self, *args, **kwargs): pass

from .globals import request

class Response(object):
    pass

def redirect(location, code=302, Response=None):
    pass

def make_response(rv):
    if isinstance(rv, str):
        return Response(rv)
    elif isinstance(rv, Response):
        return rv
    else:
        pass

def escape(txt):
    return Markup.escape(txt)
