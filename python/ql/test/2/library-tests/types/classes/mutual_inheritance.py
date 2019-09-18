from circular_inheritance import B, G, L, R

#Two way cycle
class C(B):
    pass

#Two way cycle with object
class H(G, object):
    pass

#Three way cycle
class N(L):
    pass

class T(R, object):
    pass

