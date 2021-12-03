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








if version_test:
    class F: pass
else:
    def F(): pass

f = F

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

#Check source origin of some builtins
x = None
x
t = sys.settrace
t
