# When this regression was discovered, we did not resolve the `self.f2()` call after the
# try-except block, but ONLY when passing an attribute to a method, as indicated in the
# other tests below.

class Wat(object):
    def f1(self, arg): pass
    def f2(self): pass

    def func(self, foo):
        try:
            self.f1(foo.bar) # $ pt,tt=Wat.f1
        except Exception as e:
            raise e

        self.f2() # $ pt=Wat.f2 MISSING: tt=Wat.f2


# ==============================================================================
# variants that we are able to handle
# ==============================================================================


class Works(object):
    "not using attribute"
    def f1(self, arg): pass
    def f2(self): pass

    def func(self, foo):
        try:
            self.f1(foo) # $ pt,tt=Works.f1
        except Exception as e:
            raise e

        self.f2() # $ pt,tt=Works.f2


class AlsoWorks(object):
    "no exception"
    def f1(self, arg): pass
    def f2(self): pass

    def func(self, foo):
        self.f1(foo.bar) # $ pt,tt=AlsoWorks.f1

        self.f2() # $ pt,tt=AlsoWorks.f2


def safe_func(arg):
    pass


class Works3(object):
    "call to non-self function"
    def f1(self, arg): pass
    def f2(self): pass

    def func(self, foo):
        try:
            safe_func(foo.bar) # $ pt,tt=safe_func
        except Exception as e:
            raise e

        self.f2() # $ pt,tt=Works3.f2
