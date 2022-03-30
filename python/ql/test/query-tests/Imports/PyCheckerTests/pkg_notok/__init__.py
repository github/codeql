class Foo(object):
    pass

import pkg_notok

# This import is a bit tricky. It will make `bar` available in as `pkg_notok.bar` as a
# side effect (see https://docs.python.org/3/reference/import.html#submodules), but the
# *import* will add a binding to `pkg_notok` to the current scope -- so technically the
# module imports itself.
import pkg_notok.bar

from pkg_notok import Foo
from pkg_notok import Foo as NotOkFoo
from pkg_notok import *
