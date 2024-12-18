#Don't crash looking dominators of post-return part of the expression.

def f(c):
    return
    if c:
        x
    else:
        y
    if c:
        a
    else:
        b

