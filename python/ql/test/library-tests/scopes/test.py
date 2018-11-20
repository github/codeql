
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
    func1()
    global0

#ODASA-5486
class modinit:

    _time = 0

del modinit

# FP occurs in line below
def _isstring(arg, isinstance=isinstance, t=_time):
    pass

#ODASA-4688
def outer():
    def inner():
        global glob
        glob = u'asdf'
        print(glob[2])

    def otherInner():
        print(glob[3])

    inner()
