def f_linear(x):
    y = x
    z = y
    return z

def one_branch(x):
    if x:
        return 1
    else:
        return 2

def two_branch(x, y):
    if x:
        y += 1
    else:
        y += 2
    if y:
        return 1
    else:
        return 2


def nested(x, y):
    if x:
        if y:
            return 0
        else:
            return 1
    else:
        if y:
            return 2
        else:
            return 3

def exceptions(x, y):
    try:
        x.attr
        x + y
        x[y]
        read()
    except IOError:
        pass

#ODASA-5114
def must_be_positive(self, obj, value):
    try:
        return int(value)
    except:
        self.error(obj, value)
