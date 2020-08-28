def simple_read_write():
    x = object() # $tracked=foo
    x.foo = tracked # $tracked $tracked=foo
    y = x.foo # $tracked=foo $tracked
    do_stuff(y) # $tracked

def foo():
    x = object() # $tracked=attr
    bar(x) # $tracked=attr
    x.attr = tracked # $tracked=attr $tracked
    baz(x) # $tracked=attr

def bar(x): # $tracked=attr
    z = x.attr # $tracked $tracked=attr
    do_stuff(z) # $tracked