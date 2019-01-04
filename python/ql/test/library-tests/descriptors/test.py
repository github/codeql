


class C(object):

    @property
    def f(self):
        return self._f

    @f.setter
    def f(self):
        return self._f

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
