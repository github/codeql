class Point:

    __slots__ = [ '_x', '_y' ] # Incorrect: 'Point' is an old-style class.
                               # No slots are created.
                               # Instances of Point have an attribute dictionary.

    def __init__(self, x, y):
        self._x = x
        self._y = y


class Point2(object):

    __slots__ = [ '_x', '_y' ] # Correct: 'Point2' is an new-style class
                               # Two slots '_x' and '_y' are created.
                               # Instances of Point2 have no attribute dictionary.

    def __init__(self, x, y):
        self._x = x
        self._y = y
