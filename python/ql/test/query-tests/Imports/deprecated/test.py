# Some deprecated modules
import rfc822 # $ Alert
import posixfile # $ Alert

# We should only report a bad import once
class Foo(object):
    def foo(self):
        import md5 # $ Alert

# Backwards compatible code, should not report
try:
    from hashlib import md5
except ImportError:
    from md5 import md5
