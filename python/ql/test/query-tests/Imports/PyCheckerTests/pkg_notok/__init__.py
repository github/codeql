class Foo(object):
    pass

import pkg_notok

from pkg_notok import Foo
from pkg_notok import Foo as NotOkFoo
from pkg_notok import * # TODO: TN
