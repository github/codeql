
def f1():
    pass

def f2(x, y, z):
    if x:
        pass
    elif y:
        yield 0
    elif z:
        raise z

def f3(a, b):
    if a:
        pass
    else:
        if b:
            return 0

def f4(a,b):
    while True:
        if a:
            pass
        elif b:
            try:
                call()
            except:
                raise

class C:

    def f1(self):
        pass

    def f2(self, x, y):
        if x:
            pass
        elif y:
            yield 0
        elif z:
            raise z

    def f3(self, a, b):
        if a:
            pass
        else:
            if b:
                return 0

    def f4(self, a, b):
        while True:
            if a:
                pass
            elif b:
                try:
                    call()
                except:
                    raise

def g():
    if x: a if y else b


