

def simple(func):
    func.__annotation__ = "Hello"
    return func

@simple
def foo():
    pass

def complex(msg):
    def annotate(func):
        func.__annotation__ = msg
        return func
    return annotate

@complex("Hi")
def bar():
    pass

foo
bar

class C(object):
    
    @staticmethod
    def smeth(arg0, arg1):
        arg0
        arg1
        
    @classmethod
    def cmeth(cls, arg0):
        cls
        arg0
