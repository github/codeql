

a = 1
b = 2
c = 3

from .xyz import *
from . import xyz
xyz.x
z
a

from sys import argv
#Check that points-to has inserted origin
argv

import sys
sys.argv




import code.package.x
code.package.x


from code.test_package import *
# https://bugs.python.org/issue18602
import _io
StringIO = _io.StringIO
BytesIO = _io.BytesIO

import io
StringIO = io.StringIO
BytesIO = io.BytesIO

import code.n_nesting
code.n_nesting.f2()
