
def bar(a, b=None):
    a
    b
    if b:
        return b
    else:
        return a

def foo():
    bar
    bar(11)
    bar(12, None)
    bar(13, True)
    bar(14, "")

bar
bar(21)
bar(22, None)
bar(23, True)
bar(24, "")
bar(b=7, a=3)
