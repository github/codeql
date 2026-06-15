class Foo(object):
    pass

import pkg_notok # $ Alert[py/import-and-import-from] Alert[py/import-own-module]

# This import is a bit tricky. It will make `bar` available in as `pkg_notok.bar` as a
# side effect (see https://docs.python.org/3/reference/import.html#submodules), but the
# *import* will add a binding to `pkg_notok` to the current scope -- so technically the
# module imports itself.
import pkg_notok.bar

from pkg_notok import Foo # $ Alert[py/import-own-module]
from pkg_notok import Foo as NotOkFoo # $ Alert[py/import-own-module]
from pkg_notok import * # $ Alert[py/import-own-module]
