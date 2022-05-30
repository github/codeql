def my_func():
    print("my_func")

class Foo(object):
    def __init__(self, func):
        self.indirect_ref = func
        self.direct_ref = my_func

    def later(self):
        self.indirect_ref() # $ pt=my_func MISSING: tt=my_func
        self.direct_ref() # $ pt=my_func MISSING: tt=my_func

foo = Foo(my_func) # $ tt=Foo.__init__
foo.later() # $ pt,tt=Foo.later


class DummyObject(object):
    def method(self):
        print("DummyObject.method")

class Bar(object):
    def __init__(self):
        self.obj = DummyObject()

    def later(self):
        self.obj.method() # $ pt=DummyObject.method MISSING: tt=DummyObject.method


bar = Bar(my_func) # $ tt=Bar.__init__
bar.later() # $ pt,tt=Bar.later
