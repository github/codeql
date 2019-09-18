
def del1():
    x = 0
    del x
    x = 0
    return x

def del2():
    x = 0
    if random():
        del x
    else:
        x = 1
    return x

