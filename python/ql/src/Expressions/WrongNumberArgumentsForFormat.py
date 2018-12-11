def unsafe_format():
    if unlikely_condition():
        args = (1,2)
    else:
        args = (1, 2, 3)
    return "%s %s %s" % args
