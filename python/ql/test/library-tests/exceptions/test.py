
class NotException1(object):
    pass

class NotException2(object):
    pass


class Exception1(BaseException):
    pass

class Exception2(KeyError):
    pass

class Exception3(Exception2):
    pass

def f():
    class InnerNotException1(object):
        pass

    class InnerNotException2(object):
        pass


    class InnerException1(BaseException):
        pass

    class InnerException2(KeyError):
        pass

    class InnerException3(Exception2):
        pass

try:
    some_call()
except Exception3:
    pass
except Exception2:
    pass
except Exception1:
    pass
except NotException2:
    pass
except UndefinedSymbol:
    pass
except:
    pass


def g():
    class InnerException4(Exception):
        pass
    class InnerException5(InnerException4):
        pass
    try:
        some_call()
    except Exception3:
        pass
    except NotException2:
        pass
    except InnerException5:
        pass

def h(seq):
    try:
        [x[0] for x in seq]
    except IndexError:
        pass
    except Exception1:
        pass
