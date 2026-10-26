

class ExceptionA(Exception):
    pass

class ExceptionB(Exception):
    pass

class ExceptionC(Exception):
    pass

def f1():
    pass

def f2():
    raise ExceptionA()




def f5():
    f2()

def f6():
    raise ExceptionB()
    raise IOError()

def f7():
    if x:
        raise ExceptionA()
    else:
        raise ExceptionB()

def f8():
    try:
        f7()
    except ExceptionB:
        pass

def f8a():
    try:
        f7()
    finally:
        pass

def f9():
    try:
        try:
            f7()
        except ExceptionB:
            pass
    finally:
        pass

def f10():
    try:
        try:
            f7()
        except ExceptionB:
            pass
    finally:
        return

def f11():
    try:
        try:
            f7()
        except ExceptionB:
            pass
    finally:
        raise ExceptionC()

def f12():
    x["Hello"]

def f13():
    x.attr

def f14():
    try:
        x["Hello"]
    except KeyError:
        pass

def f15():
    try:
        x[1]
    except IndexError:
        pass

def f16():
    try:
        x.attr
    except AttributeError:
        pass

def f17():
    try:
        x.attr
    except ExceptionA:
        pass

def f18():
    try:
        x["Hello"]
    finally:
        pass

def f19():
    raise IndexError()

def f20():
    try:
        f19()
    except IndexError:
        pass

def f21():
    try:
        f19()
    except KeyError:
        pass

def f22():
    try:
        f19()
    finally:
        pass

def f23():
    try:
        f7()
    finally:
        try:
            if x:
                raise ExceptionC()
        finally:
            pass

#Longer basic blocks

def f24():
    try:
        pass
        pass
        f7()
        pass
        pass
    finally:
        pass
        pass
        pass

def f25():
    try:
        pass
        pass
        f7()
        pass
        pass
    finally:
        try:
            pass
            if x:
                pass
                raise ExceptionC()
            pass
        finally:
            pass
            pass
            pass
        pass

def f26():
    try:
        pass
        pass
        f7()
        pass
        pass
    except ExceptionA:
        pass
        raise ExceptionC()

def f27():
    class A(BaseException):
        pass
    try:
        a = A()
        raise a
    except A:
        pass

def test_handled():
    try:
        func()
    except (ExceptionA, ExceptionB):
        pass
    try:
        func()
    except (ExceptionC, KeyError) as ex:
        pass

def coro():
    yield 0
    raise SpecialException()

def use_coro():
    yield coro()
    reachable

