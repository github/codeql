from functools import partial

def _path(route, view, kwargs=None, name=None, Pattern=None):
   pass

path = partial(_path, Pattern='RoutePattern (but this is a mock)')
re_path = partial(_path, Pattern='RegexPattern (but this is a mock)')
