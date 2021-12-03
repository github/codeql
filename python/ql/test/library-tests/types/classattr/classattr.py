#Test various permutations of known and unknown values, old and new style class and shadowed and unshadowed names.

from unknown import u1
i1 = 5
from unknown import g1
g2 = 7


class Old:

    a1 = g1
    a2 = g2
    u2 = u1
    u1 = u1
    i2 = i1
    i1 = i1

class New(object): 

    a1 = g1
    a2 = g2
    u2 = u1
    u1 = u1
    i2 = i1
    i1 = i1

class OldDerived(Old):
    pass

class NewDerived(New):
    pass

class Base(object):
    x = 1

class D1(Base):
    pass

class D2(Base):
    pass

class Diamond(D1, D2):
    pass

class Base2(object):
    x = 2

class D3(Base2):
    pass


class Tree(D1, D3):
    pass

class Special1(object):
    __add__ = 1

class Special2(object):
    __float__ = 2

class Special3(Special1, Special2):
    pass


