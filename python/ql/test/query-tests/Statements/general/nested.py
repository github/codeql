def f1():
    for repeated_var in range(10):
        for repeated_var in range(10):
            pass
        do_something(repeated_var)

def f2():
    for repeated_but_ok in range(10):
        if repeated_but_ok == 7:
            break
    else:
        for repeated_but_ok in range(10):
            pass
        do_something(repeated_but_ok)

def f3(y,p):
    for x in y:
        if p(y):
            for x in y:
                good1(x)
        else:
            good2(x)

def f4(y):
    for x in y:
        good1(x)
        for x in y:
            good2(x)
        bad(x)

def f5(y):
    for x in y:
        good1(x)
        temp = x
        for x in y:
            good2(x)
        x = temp
        good3(x)

def f6(y, f):
    for x in y:
        for x in y:
            good(x)
            x = f(x)
        bad(x)

def f7(y,p):
    for x in y:
        good(x)
        for x in y:
            if p(x):
                x = 1
                break
        bad(x)
