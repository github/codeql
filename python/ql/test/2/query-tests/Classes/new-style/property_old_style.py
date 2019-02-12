#Property in old-style class

class OldStyle:

    def __init__(self, x):
        self._x = x

    @property
    def piosc(self):
        return self._x