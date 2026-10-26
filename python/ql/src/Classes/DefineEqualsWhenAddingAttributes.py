class Point(object):

    def __init__(self, x, y):
        self._x = x
        self._y = y

    def __repr__(self):
        return 'Point(%r, %r)' % (self._x, self._y)

    def __eq__(self, other):
        if not isinstance(other, Point):
            return False
        return self._x == other._x and self._y == other._y

class ColorPoint(Point):

    def __init__(self, x, y, color):
        Point.__init__(self, x, y)
        self._color = color

    def __repr__(self):
        return 'ColorPoint(%r, %r)' % (self._x, self._y, self._color)

#ColorPoint(0, 0, Red) == ColorPoint(0, 0, Green) should be False, but is True.

#Fixed version
class ColorPoint(Point):

    def __init__(self, x, y, color):
        Point.__init__(self, x, y)
        self._color = color

    def __repr__(self):
        return 'ColorPoint(%r, %r)' % (self._x, self._y, self._color)

    def __eq__(self, other):
        if not isinstance(other, ColorPoint):
            return False
        return Point.__eq__(self, other) and self._color = other._color

