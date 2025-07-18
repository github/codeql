class A:
    def __init__(self):
        self.state = None 

class B(A):
    def __init__(self):
        super().__init__()
        self.state = "B"
        self.b = 3 

class C(A):
    def __init__(self):
        super().__init__()
        self.c = 2 

class D(B,C):
    def __init__(self): # GOOD: Each method calls super, so each init method runs once. self.state will be set to "B".
        super().__init__()
        self.d = 1
        


