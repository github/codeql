class ExplicitReturnInInit(object):

    def __init__(self):
        return self

# These are OK
class ExplicitReturnNoneInInit(object):

    def __init__(self):
        return None

class PlainReturnInInit(object):

    def __init__(self):
        return

def error():
    raise Exception()

class InitCallsError(object):

    def __init__(self):
        return error()

class InitCallsInit(InitCallsError):

    def __init__(self):
        return InitCallsError.__init__(self)

class InitIsGenerator(object):

    def __init__(self):
        yield self

# OK as it returns result of a call to super().__init__()
class InitCallsInit(InitCallsError):

    def __init__(self):
        return super(InitCallsInit, self).__init__()

# This is not ok, but we will only report root cause (ExplicitReturnInInit)
class InitCallsBadInit(ExplicitReturnInInit):

    def __init__(self):
        return ExplicitReturnInInit.__init__(self)

# OK as procedure implicitly returns None
#
# this was seen in the wild: https://lgtm.com/projects/b/jjburton/cgmtools/snapshot/0d8a429b7ea17854a5e5341df98b1cbd54d7fe6c/files/mayaTools/cgm/lib/classes/AttrFactory.py?sort=name&dir=ASC&mode=heatmap#L90
# using a pattern of `return procedure_that_logs_error()`

def procedure():
    pass

def explicit_none():
    return None

def explicit_none_nested():
    return explicit_none()

class InitReturnsCallResult1(object):

    def __init__(self):
        return procedure()

class InitReturnsCallResult2(object):

    def __init__(self):
        return explicit_none()

class InitReturnsCallResult3(object):

    def __init__(self):
        return explicit_none_nested()

class InitReturnsCallResult4(object):

    def __init__(self, b):
        if b:
            p = procedure
        else:
            p = explicit_none
        return p()

class InitReturnsCallResult5(object):

    def __init__(self, b):
        return procedure() if b else explicit_none()

# Not OK

def not_ok():
    return 42

class InitReturnsCallResult6(object):

    def __init__(self, b):
        if b:
            p = procedure_implicit_none()
        else:
            p = not_ok
        return p()
