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


def to_inner_scope():
    x = tracked # $tracked
    def foo():
        y = x # $ MISSING: tracked
        return y # $ MISSING: tracked
    also_x = foo() # $ MISSING: tracked
    print(also_x) # $ MISSING: tracked


def my_decorator(func):
    # This part doesn't make any sense in a normal decorator, but just shows how we
    # handle type-tracking

    func() # $tracked

    def wrapper():
        print("before function call")
        val = func() # $ MISSING: tracked
        print("after function call")
        return val # $ MISSING: tracked
    return wrapper

@my_decorator
def get_tracked2():
    return tracked # $tracked

@my_decorator
def unrelated_func():
    return "foo"

def use_funcs_with_decorators():
    x = get_tracked2() # $ MISSING: tracked
    y = unrelated_func()

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

# ------------------------------------------------------------------------------
# Tracking of self in methods
# ------------------------------------------------------------------------------

class Foo(object):

    def meth1(self):
        do_stuff(self)

    def meth2(self): # $ MISSING: tracked_self
        do_stuff(self) # $ MISSING: tracked_self

    def meth3(self): # $ MISSING: tracked_self
        do_stuff(self) # $ MISSING: tracked_self


class Bar(Foo):

    def meth1(self): # $ tracked_self
        do_stuff(self) # $ tracked_self

    def meth2(self):
        do_stuff(self)

    def meth3(self):
        do_stuff(self)

    def track_self(self): # $ tracked_self
        self.meth1() # $ tracked_self
        super().meth2()
        super(Bar, self).foo3() # $ tracked_self

# ------------------------------------------------------------------------------
# Tracking of attribute lookup after "long" import chain
# ------------------------------------------------------------------------------

def test_long_import_chain():
    import foo.bar
    foo.baz
    x = foo.bar.baz # $ tracked_foo_bar_baz
    do_stuff(x) # $ tracked_foo_bar_baz

    class Example(foo.bar.baz): # $ tracked_foo_bar_baz
        pass


def test_long_import_chain_full_path():
    from foo.bar import baz # $ tracked_foo_bar_baz
    x = baz # $ tracked_foo_bar_baz
    do_stuff(x) # $ tracked_foo_bar_baz
