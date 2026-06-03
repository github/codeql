def simple_assign():
    x = 1
    return x


def reassignment():
    x = 1
    x = 2
    return x


def if_else_branch(cond):
    if cond:
        x = 1
    else:
        x = 2
    return x


def loop(xs):
    total = 0
    for x in xs:
        total = total + x
    return total


def parameter(a, b=2, *args, **kwargs):
    return a + b + sum(args)


def closure(x):
    def inner():
        return x
    return inner


def exception_binding():
    try:
        compute()
    except Exception as e:
        return e


def with_binding():
    with open("file") as f:
        return f.read()


GLOBAL = 1


def read_global():
    return GLOBAL
