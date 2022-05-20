
class ImplicitCarrier(object):

    def __init__(self, arg):
        self.attr = arg

    def set_attr(self, arg):
        self.attr = arg

    def get_attr(self):
        return self.attr

def hub(arg):
    return arg

def test1():
    c = ImplicitCarrier(SOURCE)
    SINK(c.attr)

def test2():
    c = TAINT_CARRIER_SOURCE
    SINK(c.get_taint())

def test3():
    c = hub(ImplicitCarrier(SOURCE))
    SINK(c.get_attr())

def test4():
    c = hub(TAINT_CARRIER_SOURCE)
    SINK(c.get_taint())

def test5():
    c = ImplicitCarrier(TAINT_CARRIER_SOURCE)
    x = c.attr
    SINK(x.get_taint())
