# A very basic test of DataFlowCall
#
# see `coverage/argumentRoutingTest.ql` for a more in depth test of argument routing
# handling.

def func(arg):
    pass


class MyClass(object):
    def __init__(self, arg):
        pass

    def my_method(self, arg):
        pass

    def other_method(self):
        self.my_method(42) # $ arg[self]=self call=self.my_method(..) callType=CallTypeNormalMethod arg[position 0]=42
        self.sm(42) # $ call=self.sm(..) callType=CallTypeStaticMethod arg[position 0]=42

    @staticmethod
    def sm(arg):
        pass

    @classmethod
    def cm(cls, arg):
        pass

    @classmethod
    def other_classmethod(cls):
        cls.cm(42) # $ call=cls.cm(..) callType=CallTypeClassMethod arg[position 0]=42 arg[self]=cls
        cls.sm(42) # $ call=cls.sm(..) callType=CallTypeStaticMethod arg[position 0]=42

    def __getitem__(self, key):
        pass

func(0) # $ call=func(..) arg[position 0]=0 callType=CallTypePlainFunction

x = MyClass(1) # $ call=MyClass(..) arg[self]=[pre]MyClass(..) arg[position 0]=1 callType=CallTypeClass

x.my_method(2) # $ call=x.my_method(..) arg[self]=x arg[position 0]=2 callType=CallTypeNormalMethod
mm = x.my_method
mm(2) # $ call=mm(..) arg[self]=x arg[position 0]=2  callType=CallTypeNormalMethod
MyClass.my_method(x, 2) # $ call=MyClass.my_method(..) arg[position 0]=2 arg[self]=x callType=CallTypeMethodAsPlainFunction

x.sm(3) # $ call=x.sm(..) arg[position 0]=3  callType=CallTypeStaticMethod
MyClass.sm(3) # $ call=MyClass.sm(..) arg[position 0]=3 callType=CallTypeStaticMethod

x.cm(4) # $ call=x.cm(..) arg[position 0]=4 callType=CallTypeClassMethod
MyClass.cm(4) # $ call=MyClass.cm(..) arg[position 0]=4 arg[self]=MyClass callType=CallTypeClassMethod

x[5] # $ MISSING: call=x[5] arg[self]=x arg[position 0]=5


class Subclass(MyClass):
    pass

y = Subclass(1) # $ call=Subclass(..) arg[self]=[pre]Subclass(..) arg[position 0]=1 callType=CallTypeClass

y.my_method(2) # $ call=y.my_method(..) arg[self]=y arg[position 0]=2 callType=CallTypeNormalMethod
mm = y.my_method
mm(2) # $ call=mm(..) arg[self]=y arg[position 0]=2 callType=CallTypeNormalMethod
Subclass.my_method(y, 2) # $ call=Subclass.my_method(..) arg[self]=y arg[position 0]=2 callType=CallTypeMethodAsPlainFunction

y.sm(3) # $ call=y.sm(..) arg[position 0]=3  callType=CallTypeStaticMethod
Subclass.sm(3) # $ call=Subclass.sm(..) arg[position 0]=3 callType=CallTypeStaticMethod

y.cm(4) # $ call=y.cm(..) arg[position 0]=4 callType=CallTypeClassMethod
Subclass.cm(4) # $ call=Subclass.cm(..) arg[self]=Subclass arg[position 0]=4 callType=CallTypeClassMethod

y[5] # $ MISSING: call=y[5] arg[self]=y arg[position 0]=5


try:
    # These are included to show whether we have a DataFlowCall for things we can't
    # resolve. Both are interesting since with points-to we used to have a DataFlowCall
    # for _one_ but not the other
    import mypkg
    mypkg.foo(42)
    mypkg.subpkg.bar(43)
except:
    pass
