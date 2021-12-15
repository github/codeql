
#Global or builtin
if a:
    float = True
pass

class C2(object):

    i1 = int
    f1 = float
    #local
    int = 0
    if b:
        #local or builtin
        str = 1.0
        #local, global or builtin
        float = None
    i2 = int
    s = str
    f2 = float

x = x
i = int
f = float
