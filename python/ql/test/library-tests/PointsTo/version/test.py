import sys












os_test = sys.platform == "win32"
version_test = sys.version_info < (3,)

from module import os_test as t2
from module import version_test as t3


# Tests from six
PY2 = sys.version_info[0] == 2
PY3 = sys.version_info[0] == 3

if PY2:
    version = 2

if PY3:
    version = 3

if version == 2:
    print("Version 2")

if t2:
    class G: pass
else:
    def G(): pass

g = G

if t3:
    class H: pass
else:
    def H(): pass

h = H

#Some other forms of check.

#Hexversion check (unlikely but a valid test)
PY2a = sys.hexversion < 0x03000000
PY3a = sys.hexversion >= 0x03000000

PY2b = sys.hexversion < 0x03000000
PY3b = sys.hexversion >= 0x03000000

PY2c = sys.version_info < (3,)
PY3c = sys.version_info >= (3,)
Py3d = sys.version_info >= (3,4) # Specific version of Python 3, rules out Python 2
Py2d = sys.version_info < (2,7) 
Py3e = sys.version_info[:2] >= (3,3)
Py2f = sys.version_info[:2] < (2,7)

#From problem_report
Py2g = sys.version[0] < '3'
Py3h = sys.version[0] >= '3'

if os_test:
    pass

