class A:
    def __init__(self):
        print("A")
        self.state = None 

class B(A):
    def __init__(self):
        print("B")
        super().__init__() # When called from D, this calls C.__init__
        self.state = "B"
        self.b = 3 

class C(A):
    def __init__(self):
        print("C")
        super().__init__()
        self.c = 2 

class D(B,C):
    def __init__(self): 
        B.__init__(self)
        C.__init__(self) # BAD: C.__init__ is called a second time