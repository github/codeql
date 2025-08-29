class A:
    def __init__(self, a):
        self.a = a

    # OK: __ne__ if not defined delegates to eq automatically
    def __eq__(self, other):
        return self.a == other.a 

assert (A(1) == A(1))
assert not (A(1) == A(2))
assert not (A(1) != A(1))
assert (A(1) != A(2))

class B: # $ Alert 
    def __init__(self, b):
        self.b = b

    # BAD: eq defaults to `is`
    def __ne__(self, other):
        return self.b != other.b 

assert not (B(1) == B(1)) # potentially unexpected
assert not (B(2) == B(2))
assert not (B(1) != B(1))
assert (B(1) != B(2))

class C:
    def __init__(self, c):
        self.c = c 

    def __eq__(self, other):
        return self.c == other.c 

    def __ne__(self, other):
        return self.c != other.c 

class D(C): # $ Alert 
    def __init__(self, c, d):
        super().__init__(c)
        self.d = d

    # BAD: ne is not defined, but the superclass ne is used instead of delegating, which may be incorrect
    def __eq__(self, other):
        return self.c == other.c and self.d == other.d

assert (D(1,2) == D(1,2))
assert not (D(1,2) == D(1,3))
assert (D(1,2) != D(3,2)) 
assert not (D(1,2) != D(1,3)) # Potentially unexpected 

class E:
    def __init__(self, e):
        self.e = e 

    def __eq__(self, other):
        return self.e == other.e 

    def __ne__(self, other):
        return not self.__eq__(other)

class F(E): 
    def __init__(self, e, f):
        super().__init__(e)
        self.f = f

    # OK: superclass ne delegates to eq
    def __eq__(self, other):
        return self.e == other.e and self.f == other.f

assert (F(1,2) == F(1,2))
assert not (F(1,2) == F(1,3))
assert (F(1,2) != F(3,2)) 
assert (F(1,2) != F(1,3))

# Variations 

class E2:
    def __init__(self, e):
        self.e = e 

    def __eq__(self, other):
        return self.e == other.e 

    def __ne__(self, other):
        return not self == other

class F2(E2): 
    def __init__(self, e, f):
        super().__init__(e)
        self.f = f

    # OK: superclass ne delegates to eq
    def __eq__(self, other):
        return self.e == other.e and self.f == other.f

assert (F2(1,2) == F2(1,2))
assert not (F2(1,2) == F2(1,3))
assert (F2(1,2) != F2(3,2)) 
assert (F2(1,2) != F2(1,3))

class E3:
    def __init__(self, e):
        self.e = e 

    def __eq__(self, other):
        return self.e == other.e 

    def __ne__(self, other):
        return not other.__eq__(self)

class F3(E3): 
    def __init__(self, e, f):
        super().__init__(e)
        self.f = f

    # OK: superclass ne delegates to eq
    def __eq__(self, other):
        return self.e == other.e and self.f == other.f

assert (F3(1,2) == F3(1,2))
assert not (F3(1,2) == F3(1,3))
assert (F3(1,2) != F3(3,2)) 
assert (F3(1,2) != F3(1,3))

class E4:
    def __init__(self, e):
        self.e = e 

    def __eq__(self, other):
        return self.e == other.e 

    def __ne__(self, other):
        return not other == self

class F4(E4): 
    def __init__(self, e, f):
        super().__init__(e)
        self.f = f

    # OK: superclass ne delegates to eq
    def __eq__(self, other):
        return self.e == other.e and self.f == other.f

assert (F4(1,2) == F4(1,2))
assert not (F4(1,2) == F4(1,3))
assert (F4(1,2) != F4(3,2)) 
assert (F4(1,2) != F4(1,3))