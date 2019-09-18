

class A(object):

    def __init__(self):
        raise NotImplementedError

    def _meth(self):
        raise NotImplementedError

class B(A):

    def _meth(self):
        "Still abstract"

class C(A):
    pass

class D(B):

    def __init__(self):
        "Not abstract"

class E(A):

    def __init__(self):
        "Still abstract"

class F(E):

    def _meth(self):
        "Not abstract"
