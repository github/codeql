#Attribute set in both superclass and subclass
class C(object):

    def __init__(self):
        self.var = 0

class D(C):

    def __init__(self):
        self.var = 1 # self.var will be overwritten
        C.__init__(self)

#Attribute set in both superclass and subclass
class E(object):

    def __init__(self):
        self.var = 0 # self.var will be overwritten

class F(E):

    def __init__(self):
        E.__init__(self)
        self.var = 1
