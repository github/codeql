def return_three():
    return 3

def return_two():
    return 2

def f1():
    return 3 / 2

def f2():
    return return_three() / return_two()

def f3(x):
    if isinstance(x, float):
        return x / 2
    else:
        return (1.0 * x) / 2

def f4():
    do_stuff(f3(1))
    do_stuff(f3(1.0))

def f5():
    return int(return_three() / return_two())
