class B(object):

    def __init__(self, arg):
        print('B.__init__', arg)
        self._arg = arg

    def __str__(self):
        print('B.__str__')
        return 'B (arg={})'.format(self.arg)

    def __add__(self, other):
        print('B.__add__')
        if isinstance(other, B):
            return B(self.arg + other.arg)
        return B(self.arg + other)

    @property
    def arg(self):
        print('B.arg getter')
        return self._arg

    @arg.setter
    def arg(self, value):
        print('B.arg setter')
        self._arg = value


b1 = B(1)
b2 = B(2)
b3 = b1 + b2

print('value printing:', str(b1))
print('value printing:', str(b2))
print('value printing:', str(b3))

b3.arg = 42
b4 = b3 + 100

# this calls `str(b4)` inside
print('value printing:', b4)
