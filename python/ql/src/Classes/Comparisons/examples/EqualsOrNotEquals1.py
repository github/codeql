class A:
    def __init__(self, a):
        self.a = a 

    # BAD: ne is defined, but not eq.
    def __ne__(self, other):
        if not isinstance(other, A):
            return NotImplemented 
        return self.a != other.a

x = A(1)
y = A(1)

print(x == y) # Prints False (potentially unexpected - object identity is used)
print(x != y) # Prints False
