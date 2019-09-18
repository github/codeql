class PointOriginal(object):

    def __init__(self, x, y):
        self._x, x
        self._y = y

    def __repr__(self):
        return 'Point(%r, %r)' % (self._x, self._y)

    def __eq__(self, other):  # Incorrect: equality is defined but inequality is not
        if not isinstance(other, Point):
            return False
        return self._x == other._x and self._y == other._y


class PointUpdated(object):

    def __init__(self, x, y):
        self._x, x
        self._y = y

    def __repr__(self):
        return 'Point(%r, %r)' % (self._x, self._y)

    def __eq__(self, other):
        if not isinstance(other, Point):
            return False
        return self._x == other._x and self._y == other._y

    def __ne__(self, other):  # Improved: equality and inequality method defined (hash method still missing)
        return not self == other

