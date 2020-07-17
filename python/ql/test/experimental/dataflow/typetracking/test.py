def get_tracked():
    x = tracked
    return x

def use_tracked(x):
    do_stuff(x)

def foo():
    use_tracked(get_tracked())

def bar():
    x = get_tracked()
    use_tracked(x)

def baz():
    x = tracked
    use_tracked(x)

foo()
bar()
baz()