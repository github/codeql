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



class A:
    def __init__(self, a):
        self.a = a 

    def __eq__(self, other):
        print("A eq")
        return self.a == other.a

    def __ne__(self, other):
        print("A ne")
        return self.a != other.a 

class B(A):
    def __init__(self, a, b):
        self.a = a
        self.b = b 

    def __eq__(self, other):
        print("B eq")
        return self.a == other.a and self.b == other.b

print(B(1,2) != B(1,3)) 
