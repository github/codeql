
#Import and import from

import test_module2 # $ Alert[py/import-and-import-from]
from test_module2 import func

#Module imports itself
import imports_test # $ Alert[py/import-own-module]

import pkg_ok
import pkg_notok
