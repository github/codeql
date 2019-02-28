

from ._helper import expose, popargs, url

class _ThreadLocalProxy(object):
    def __getattr__(self, name):
        pass


request = _ThreadLocalProxy('request')
response = _ThreadLocalProxy('response')

def quickstart(root=None, script_name='', config=None):
    """Mount the given root, start the builtin server (and engine), then block."""
    pass
