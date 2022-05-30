class Foo(object):
    def meth(self, arg):
        print("Foo.meth", arg)

    @classmethod
    def cm(cls, arg):
        print("Foo.cm", arg)


def call_func(func):
    func(42) # $ pt,tt=Foo.meth pt,tt=Foo.cm


foo = Foo()
call_func(foo.meth) # $ pt,tt=call_func
call_func(Foo.cm) # $ pt,tt=call_func
