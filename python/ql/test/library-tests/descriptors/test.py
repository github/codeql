class WithDecorator(object):
    def __init__(self):
        self._x = None

    @property
    def x(self):
        """I'm the 'x' property."""
        return self._x

    @x.setter
    def x(self, value):
        self._x = value

    @x.deleter
    def x(self):
        del self._x

class WithDecoratorOnlyGetter(object):

    @property
    def x(self):
        return 42

class WithoutDecorator(object):
    def __init__(self):
        self._x = None

    def getx(self):
        return self._x

    def setx(self, value):
        self._x = value

    def delx(self):
        del self._x

    x = property(getx, setx, delx, "I'm the 'x' property.")

class WithoutDecoratorOnlyGetter(object):

    def getx(self):
        return 42

    x = property(getx)

class WithoutDecoratorOnlySetter(object):

    def setx(self, value):
        self._x = value

    x = property(fset=setx) # TODO: Not handled

class D(object):

    @classmethod
    def c1(self):
        pass

    def c2(self):
        pass

    c3 = classmethod(c2)
    c2 = classmethod(c2)

    @staticmethod
    def s1(self):
        pass

    def s2(self):
        pass

    s3 = staticmethod(s2)
    s2 = staticmethod(s2)
