
class OldStyle:

    def __init__(self, x):
        self._x = x

    # Incorrect: 'OldStyle' is not a new-style class and '@property' is not supported
    @property
    def x(self):
        return self._x


class InheritOldStyle(OldStyle):

    def __init__(self, x):
        self._x = x

    # Incorrect: 'InheritOldStyle' is not a new-style class and '@property' is not supported
    @property
    def x(self):
        return self._x


class NewStyle(object):

    def __init__(self, x):
        self._x = x

    # Correct: 'NewStyle' is a new-style class and '@property' is supported
    @property
    def x(self):
        return self._x

class InheritNewStyle(NewStyle):

    def __init__(self, x):
        self._x = x

    # Correct: 'InheritNewStyle' inherits from a new-style class and '@property' is supported
    @property
    def x(self):
        return self._x
