#Test module for the NameSpace QL class

def func():
    pass

x = 0
y = 1

class Class:

    def meth(self):
        pass

from module import x
from module import z as y
import module

meth = Class.meth
q = Class().meth()
m_z = module.z

# Hierarchical scopes

#Global
int = b"global"

#Global or builtin
if unknown():
    float = b"global"

class C2:

    i1 = int
    f1 = float
    #local
    int = u"class-local"
    if unknown:
        #local or builtin
        str = u"class-local"
        #local, global or builtin
        float = u"class-local"
    i2 = int
    s = str
    f2 = float

x = x
i = int
f = float

