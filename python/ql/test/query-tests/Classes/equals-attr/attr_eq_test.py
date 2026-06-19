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

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash((self._x, self._y))

class BadColorPoint(Point):

    def __init__(self, x, y, color):
        Point.__init__(self, x, y)
        self._color = color

    def __repr__(self):
        return 'ColorPoint(%r, %r)' % (self._x, self._y, self._color)

class GoodColorPoint(Point):

    def __init__(self, x, y, color):
        Point.__init__(self, x, y)
        self._color = color

    def __repr__(self):
        return 'ColorPoint(%r, %r)' % (self._x, self._y, self._color)

    def __eq__(self, other):
        if not isinstance(other, GoodColorPoint):
            return False
        return Point.__eq__(self, other) and self._color == other._color

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash((self._x, self._y, self._color))

class GenericPoint(object):

    def __init__(self, x, y):
        self._x = x
        self._y = y

    def __repr__(self):
        return 'Point(%r, %r)' % (self._x, self._y)

    def __eq__(self, other):
        return self.__class__ == other.__class__ and self.__dict__ == other.__dict__

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash((self._x, self._y))

class GoodGenericColorPoint(GenericPoint):

    def __init__(self, x, y, color):
        GenericPoint.__init__(self, x, y)
        self._color = color
        
class RedefineEq(object):

    def __init__(self, x, y):
        self._x = x
        self._y = y

    def __eq__(self, other):
        return self is other
    
class OK1(RedefineEq):

    def __init__(self, x, y, z):
        RedefineEq.__init__(self, x, y)
        self.z = z

class OK2(GenericPoint):

    def __init__(self, x, y, color):
        GenericPoint.__init__(self, x, y)
        self._color = color
      
    def __eq__(self, other):
        return self is other

class ExpectingAttribute(object):
    
    def __eq__(self, other):
        return self.x == other.x

class OK3(ExpectingAttribute):
    
    def __init__(self):
        self.x = 4

