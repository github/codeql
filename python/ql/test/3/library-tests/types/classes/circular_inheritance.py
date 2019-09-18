from mutual_inheritance import C, H, N, T

#Good newstyle (in Python2) classes

class W(object):
    pass

class X(W):
    pass

class Y(X):
    pass

class Z(Y, X):
    pass

#Good oldstyle (in Python2) classes

class O1:
    pass

class O2(O1):
    pass

class O3(O1):
    pass

class O4(O2, O3):
    pass

#Bad classes -- Illegal and designed to break MRO computation

class A(A):
    pass

#Two way cycle
class B(C):
    pass

class D(object, object, object, object, object, object, object, object):
    pass

class E(D, D, D, D, D, D, D, D, D, D, D):
    pass

#Two way cycle with object
class G(H, object):
    pass

class J(J, object):
    pass # Not a cycle as J is undefined when used as a base.

#Three way cycle
class M(N):
    pass

class L(M):
    pass

#Three way cycle with object
class S(T, object):
    pass

class R(S, object):
    pass


