import random
cond = random.randint(0,1) == 1

# ------------------------------------------------------------------------------
# Calling different bound-methods based on conditional
# ------------------------------------------------------------------------------

class CrosstalkTestX:
    def __init__(self):
        self.x = None
        self.y = None

    def setx(self, value):
        self.x = value

    def setvalue(self, value):
        self.x = value


class CrosstalkTestY:
    def __init__(self):
        self.x = None
        self.y = None

    def sety(self ,value):
        self.y = value

    def setvalue(self, value):
        self.y = value


objx = CrosstalkTestX()
objy = CrosstalkTestY()

if cond:
    func = objx.setx
else:
    func = objy.sety

# What we're testing for is whether both objects are passed as self to both methods,
# which is wrong.

func(42)


if cond:
    func = objx.setvalue
else:
    func = objy.setvalue

func(43)

# ------------------------------------------------------------------------------
# Calling methods in different ways
# ------------------------------------------------------------------------------

class A(object):
    def foo(self, arg="Default"):
        print("A.foo", self, arg)

a = A()
if cond:
    func = a.foo # `44` is passed as arg
else:
    func = A.foo # `44` is passed as self

# What we're testing for is whether a single call ends up having both `a` and `44` is
# passed as self to `A.foo`, which is wrong.

func(44)
