import sys

class C:
    pass

class D:
    pass

if x:
    v1 = C
else:
    v1 = D


version_test = sys.version_info < (3,)


from module import version_test as t3
#We want to run all the tests on all OSes, so omit this test for now.
#if os_test:
#    class E: pass
#else:
#    def E(): pass
#
#e = E

if version_test:
    class F: pass
else:
    def F(): pass

f = F








if t3:
    class H: pass
else:
    def H(): pass

h = H

#Check source origin of some builtins
x = None
x
t = sys.settrace
t

def func():
    pass

#type(x)
c = type(C())
t = type(C)
x = type(unknown)
g = type(func())

import module

if module.version_2:
    class J: pass
else:
    def J(): pass

j = J()
