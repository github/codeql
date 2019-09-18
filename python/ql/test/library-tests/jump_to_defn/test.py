
import module
from module import C
from module import f

def func(arg):
    C.sm(arg)
    C().m(arg)
    f(arg)
    module.C.sm(arg)
    module.C().m(arg)
    module.f(arg)

def no_phi_defn(seq, cond):
    x = seq[0]
    if cond:
        x = seq[1]
    pass
    x

class D(object):

    cls_attr = (
        3
    )

    def __init__(self):
        pass

    def meth(self):
        return self.cls_attr

D.cls_attr


class BaseClass(object):

    def __init__(self):
        pass

class DerivedClass(BaseClass):

    def __init__(self):
        BaseClass.__init__(self)
        m = super(DerivedClass, self).__init__
        m()

