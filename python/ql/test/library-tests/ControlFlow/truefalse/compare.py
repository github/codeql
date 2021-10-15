
def contains1(item, cont):
    assert item in cont
    return 1

def contains2(item, cont):
    assert item not in cont
    return 2

def contains3(item, cont):
    if item in cont:
        return 3
    else:
        return 3.0

def contains4(item, cont):
    if item not in cont:
        return 4
    else:
        return 4.0
