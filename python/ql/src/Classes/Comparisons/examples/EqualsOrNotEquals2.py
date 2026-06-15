class B:
    def __init__(self, b):
        self.b = b 
    
    def __eq__(self, other):
        return self.b == other.b 
    
    def __ne__(self, other):
        return self.b != other.b 
    
class C(B):
    def __init__(self, b, c):
        super().__init__(b)
        self.c = c 

    # BAD: eq is defined, but != will use superclass ne method, which is not consistent
    def __eq__(self, other):
        return self.b == other.b and self.c == other.c 
    
print(C(1,2) == C(1,3)) # Prints False 
print(C(1,2) != C(1,3)) # Prints False (potentially unexpected)