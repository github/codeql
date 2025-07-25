class A:
    def __init__(self, a):
        self.a = a 

    def __add__(self, other):
        # BAD: Should return NotImplemented instead of raising
        if not isinstance(other,A):
            raise TypeError(f"Cannot add A to {other.__class__}")
        return A(self.a + other.a)

class B:
    def __init__(self, a):
        self.a = a 

    def __add__(self, other):
        # GOOD: Returning NotImplemented allows for the operation to fallback to other implementations to allow other classes to support adding to B.
        if not isinstance(other,B):
            return NotImplemented
        return B(self.a + other.a)
    

        
