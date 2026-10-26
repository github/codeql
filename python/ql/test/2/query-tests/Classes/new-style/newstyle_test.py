
#Only works for Python2

class OldStyle1: # $ Alert[py/slots-in-old-style-class]

    __slots__ = [ 'a', 'b' ]

    def __init__(self, a, b):
        self.a = a
        self.b = b

class OldStyle2:

    def __init__(self, x):
        super().__init__(x) # $ Alert[py/super-in-old-style]

class NewStyle1(object):

    def __init__(self, y):
        super().__init__(y)
