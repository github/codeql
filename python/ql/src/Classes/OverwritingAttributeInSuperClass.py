
#Attribute set in both superclass and subclass
class C(object):

    def __init__(self):
        self.var = 0

class D(C):

    def __init__(self):
        self.var = 1 # self.var will be overwritten
        C.__init__(self)

class E(object):

    def __init__(self):
        self.var = 0 # self.var will be overwritten

class F(E):

    def __init__(self):
        E.__init__(self)
        self.var = 1

#Fixed version -- Pass explicitly as a parameter
class G(object):

    def __init__(self, var = 0):
        self.var = var

class H(G):

    def __init__(self):
        G.__init__(self, 1)

