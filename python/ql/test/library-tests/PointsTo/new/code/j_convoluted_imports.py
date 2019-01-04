
from code.package \
import module

from code.package \
import x
#Should work correctly in nested scopes as well.

class C(object):

    from code.package import module2

    def f(self):
        from code.package import x

from code.package import moduleX
moduleX.Y
