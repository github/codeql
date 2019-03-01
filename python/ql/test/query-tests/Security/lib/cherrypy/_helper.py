def expose(func=None, alias=None):
    """Expose the function or class.
    Optionally provide an alias or set of aliases.
    """
    def expose_(func):
        func.exposed = True
        return func

    return expose_


def popargs(*args, **kwargs):
    """Decorate _cp_dispatch."""

    def decorated(cls_or_self=None, vpath=None):
        if inspect.isclass(cls_or_self):
            # cherrypy.popargs is a class decorator
            return cls

        # We're in the actual function
        self = cls_or_self
        if vpath:
            return getattr(self, vpath.pop(0), None)
        else:
            return self

    return decorated

def url(path='', qs='', script_name=None, base=None, relative=None):
    #Do some opaque stuff here...
    return new_url
