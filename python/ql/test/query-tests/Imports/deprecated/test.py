# Some deprecated modules
import rfc822
import posixfile

# We should only report a bad import once
class Foo(object):
    def foo(self):
        import md5

# Backwards compatible code, should not report
try:
    from hashlib import md5
except ImportError:
    from md5 import md5
