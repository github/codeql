class Base(object):

    def __init__(self, arg):
        print("Base.__init__", arg)
        self.arg = arg

    def __str__(self):
        print("Base.__str__")
        return 'Base STR (arg={})'.format(self.arg)

    def __add__(self, other):
        print("Base.__add__")
        if isinstance(other, Base):
            return Base(self.arg + other.arg) # $ tt=Base.__init__
        return Base(self.arg + other) # $ tt=Base.__init__

    def __call__(self, val):
        print("Base.__call__", val)

    def wat(self):
        print("Base.wat")
        self(43) # $ tt=Base.__call__ tt=Sub.__call__


b = Base(1) # $ tt=Base.__init__

print(str(b))
# this calls `str(b)` inside
print(b)

print("\n! calls")

b(42) # $ tt=Base.__call__
b.wat() # $ pt,tt=Base.wat

b.__call__(44) # $ pt,tt=Base.__call__

print("\n! b2")
b2 = Base(2) # $ tt=Base.__init__


b + b2 # $ MISSING: tt=Base.__add__
b + 100 # $ MISSING: tt=Base.__add__


# ========
print("\n! Sub")

class Sub(Base):
    def __add__(self, other):
        print("Sub.__add__")

    def __call__(self, arg):
        print("Sub.__call__", arg)

sub = Sub(10) # $ tt=Base.__init__
sub + 42

sub(55) # $ tt=Sub.__call__
sub.wat() # $ pt,tt=Base.wat

# not possible to indirectly access addition of subclass
try:
    super(Sub, sub) + 143
except TypeError:
    print("TypeError as expected")
