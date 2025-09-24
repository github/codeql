class A:
    def __init__(self):
        self.state = None 

class B(A):
    def __init__(self):
        A.__init__(self)
        self.state = "B"
        self.b = 3 

class C(A):
    def __init__(self):
        A.__init__(self)
        self.c = 2 

class D(B,C):
    def __init__(self):
        B.__init__(self)
        C.__init__(self) # BAD: This calls A.__init__ a second time, setting self.state to None.
        
