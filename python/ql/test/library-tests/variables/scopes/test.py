
global0 = 0
global1 = 1

def func0(param0, param1):
    return param0 + param1

def func1():
    global global0, global_local
    local0 = 0
    local1 = 1
    global_local
    global0 = local0 + local1 + global1

def func2():
    local2 = 2
    def inner1(param2):
        local3 = local2
        return local3
    return inner1

def func3(param4, param5):
    local4 = 4
    def inner_outer():
        def inner2(param3):
            return local5 + local4 + param3 + param4
        local5 = 3
        return inner2(local4 + param4 + param5)

class C(base):

    class_local = 7

    def meth(self):
        mlocal = self
        return mlocal

def func4(param6):
    class Local:
        def meth_inner(self):
            return param6
    return Local()

def func5(seq):
    return [x for x in seq]

def func6(y, z):
    return [y+z for y in seq]

#FP observed in sembuild
def use_in_loop(seq):
    [v for v in range(3)]
    for v in seq:
        v #x redefined -- fine in 2 and 3.
