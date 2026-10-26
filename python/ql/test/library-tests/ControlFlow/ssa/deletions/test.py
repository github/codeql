from mod import cond

del u1

if cond:
    u2 = 0
del u2

del u3
use(u3)


def f():
    del u1
    
    if cond:
        u2 = 0
    del u2
    
    del u3
    use(u3)