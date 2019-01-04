

def foo(x = []):
    return x.append("x")

def bar(x = []):
    return len(x)

foo()
bar()

class Owner(object):

    @classmethod
    def cm(cls, arg):
        return cls

    @classmethod
    def cm2(cls, arg):
        return arg

    #Normal method
    def m(self):
        a = self.cm(0)
        return a.cm2(1)

