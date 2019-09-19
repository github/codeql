# Using name other than 'self' for first argument in methods.
# This shouldn't apply to classmethods (first argument should be 'cls' or similar)
# or static methods (first argument can be anything)


class Normal(object):

    def n_ok(self):
        pass

    @staticmethod
    def n_smethod(ok):
        pass

    # not ok
    @classmethod
    def n_cmethod(self):
        pass

    # this is allowed because it has a decorator other than @classmethod
    @classmethod
    @id
    def n_suppress(any_name):
        pass


class Class(type):

    def __init__(cls):
        pass

    def c_method(y):
        pass

    def c_ok(cls):
        pass

    @id
    def c_suppress(any_name):
        pass


class NonSelf(object):

    def __init__(x):
        pass

    def s_method(y):
        pass

    def s_ok(self):
        pass

    @staticmethod
    def s_smethod(ok):
        pass

    @classmethod
    def s_cmethod(cls):
        pass

    def s_smethod2(ok):
        pass
    s_smethod2 = staticmethod(s_smethod2)

    def s_cmethod2(cls):
        pass
    s_cmethod2 = classmethod(s_cmethod2)
