
def unsafe_format():
    if unlikely_condition():
        args = (1,2,3)
    else:
        args = {a:1,b:2,c:3}
    return "%(a)s %(b)s %(c)s" % args