class B(object):

    def __init__(self, arg):
        print('B.__init__', arg)
        self.arg = arg

    def __str__(self):
        print('B.__str__')
        return 'B (arg={})'.format(self.arg)

    def __add__(self, other):
        print('B.__add__')
        if isinstance(other, B):
            return B(self.arg + other.arg) # $ tt=B.__init__
        return B(self.arg + other) # $ tt=B.__init__

b = B(1) # $ tt=B.__init__

print(str(b))
# this calls `str(b)` inside
print(b)



b2 = B(2) # $ tt=B.__init__

# __add__ is called
b + b2
b + 100
