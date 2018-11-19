
#Convoluted object initialisation and self attribute use.
class C(object):

    def __init__(self):
        self._init()
        self.x = 1

    def _init(self):
        self.y = 2
        self._init2()

    def _init2(self):
        self.z = 3

    def method(self):
        use(self.x)
        if isinstance(self.y, int):
            use(self.y)
        use(self.z)
        pass # Give phi nodes a location


class Oddities(object):

    int = int
    float = float
    l = len
    h = hash


class D(object):

    def __init__(self):
        super(D, self).x
        return super(D, self).__init__()



#ODASA-4519
#OK as we are using identity tests for unique objects
V2 = "v2"
V3 = "v3"

class E(object):
    def __init__(self, c):
        if c:
            self.version = V2
        else:
            self.version = V3

    def meth(self):
        if self.version is V2:    #FP here.
            pass
