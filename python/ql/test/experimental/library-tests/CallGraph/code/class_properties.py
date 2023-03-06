def func():
    print("func")

class Prop(object):
    def __init__(self, arg):
        self._arg = arg
        self._arg2 = arg

    @property
    def arg(self):
        print('Prop.arg getter')
        return self._arg

    @arg.setter
    def arg(self, value):
        print('Prop.arg setter')
        self._arg = value

    @arg.deleter
    def arg(self):
        print('Prop.arg deleter')
        # haha, you cannot delete me!

    def _arg2_getter(self):
        print('Prop.arg2 getter')
        return self._arg2

    def _arg2_setter(self, value):
        print('Prop.arg2 setter')
        self._arg2 = value

    def _arg2_deleter(self):
        print('Prop.arg2 deleter')
        # haha, you cannot delete me!

    arg2 = property(_arg2_getter, _arg2_setter, _arg2_deleter)

    @property
    def func_prop(self):
        print("Prop.func_prop getter")
        return func

prop = Prop(42) # $ tt=Prop.__init__

prop.arg
prop.arg = 43
del prop.arg

prop.arg2
prop.arg2 = 43
del prop.arg2

f = prop.func_prop
f() # $ MISSING: tt=func
