# This import makes `pkg_ok` available, but also `foo1` (surprising as it may be)
import pkg_ok.foo1 # TODO: FP

from pkg_ok import foo2 # TODO: FP
from pkg_ok.foo3 import Foo3 # TODO: FP

from . import foo4 # TODO: FP
from .foo5 import Foo5 # TODO: FP
