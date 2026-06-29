#Property in old-style class

class OldStyle:

    def __init__(self, x):
        self._x = x

    @property # $ Alert[py/property-in-old-style-class]
    def piosc(self):
        return self._x