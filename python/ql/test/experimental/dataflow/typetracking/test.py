def get_tracked():
    x = tracked # $tracked
    return x # $tracked

def use_tracked_foo(x): # $tracked
    do_stuff(x) # $tracked

def foo():
    use_tracked_foo(
        get_tracked() # $tracked
    )

def use_tracked_bar(x): # $tracked
    do_stuff(x) # $tracked

def bar():
    x = get_tracked() # $tracked
    use_tracked_bar(x) # $tracked

def use_tracked_baz(x): # $tracked
    do_stuff(x) # $tracked

def baz():
    x = tracked # $tracked
    use_tracked_baz(x) # $tracked

def id(x): # $tracked
    return x # $tracked

def use_tracked_quux(x): # $ MISSING: tracked
    do_stuff(y) # call after return -- not tracked in here.

def quux():
    x = tracked # $tracked
    y = id(x) # $tracked
    use_tracked_quux(y) # not tracked out of call to id.

g = None

def write_g(x): # $tracked
    global g
    g = x # $tracked

def use_g():
    do_stuff(g) # $tracked

def global_var_write_test():
    x = tracked # $tracked
    write_g(x) # $tracked
    use_g()

def test_import():
    import mymodule
    mymodule.x # $tracked
    y = mymodule.func() # $tracked
    y # $tracked
    mymodule.z # $tracked

# ------------------------------------------------------------------------------

def expects_int(x): # $int
    do_int_stuff(x) # $int

def expects_string(x): # $str
    do_string_stuff(x) # $str

def redefine_test():
    x = int(5) # $int
    expects_int(x) # $int
    x = str("Hello") # $str
    expects_string(x) # $str
