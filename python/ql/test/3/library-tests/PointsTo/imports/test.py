from package \
import module

from package \
import x
#Should work correctly in nested scopes as well.

class C(object):

    from package import module2

    def f(self):
        from package import x

from package import moduleX
moduleX.Y

#A small stdlib module to test version handling.
import tty

#Check imports of builtin-objects using import * with no corresponding variable.
x.exc_info

argv = 0

try:
    from sys import *
except:
    pass

argv

from socket import *
timeout
