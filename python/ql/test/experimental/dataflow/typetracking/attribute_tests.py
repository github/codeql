class SomeClass:
    pass

def simple_read_write():
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked tracked=foo
    y = x.foo # $tracked=foo tracked
    do_stuff(y) # $tracked

def foo():
    x = SomeClass() # $tracked=attr
    bar(x) # $tracked=attr
    x.attr = tracked # $tracked=attr tracked
    baz(x) # $tracked=attr

def bar(x): # $tracked=attr
    z = x.attr # $tracked tracked=attr
    do_stuff(z) # $tracked

def expects_int(x): # $int=field SPURIOUS: str=field
    do_int_stuff(x.field) # $int int=field SPURIOUS: str str=field

def expects_string(x): # $ str=field SPURIOUS: int=field
    do_string_stuff(x.field) # $str str=field SPURIOUS: int int=field

def test_incompatible_types():
    x = SomeClass() # $int,str=field
    x.field = int(5) # $int=field int SPURIOUS: str=field str
    expects_int(x) # $int=field SPURIOUS: str=field
    x.field = str("Hello") # $str=field str SPURIOUS: int=field int
    expects_string(x) # $ str=field SPURIOUS: int=field


# Attributes assigned statically to a class

class MyClass: # $tracked=field
    field = tracked # $tracked

lookup = MyClass.field # $tracked tracked=field
instance = MyClass() # $tracked=field
lookup2 = instance.field # MISSING: tracked

## Dynamic attribute access

# Via `getattr`/`setattr`

def setattr_immediate_write():
    x = SomeClass() # $tracked=foo
    setattr(x,"foo", tracked) # $tracked tracked=foo
    y = x.foo # $tracked tracked=foo
    do_stuff(y) # $tracked

def getattr_immediate_read():
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked tracked=foo
    y = getattr(x,"foo") # $tracked tracked=foo
    do_stuff(y) # $tracked

def setattr_indirect_write():
    attr = "foo"
    x = SomeClass() # $tracked=foo
    setattr(x, attr, tracked) # $tracked tracked=foo
    y = x.foo # $tracked tracked=foo
    do_stuff(y) # $tracked

def getattr_indirect_read():
    attr = "foo"
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked tracked=foo
    y = getattr(x, attr) #$tracked tracked=foo
    do_stuff(y) # $tracked

# Via `__dict__` -- not currently implemented.

def dunder_dict_immediate_write():
    x = SomeClass() # $ MISSING: tracked=foo
    x.__dict__["foo"] = tracked # $tracked MISSING: tracked=foo
    y = x.foo # $ MISSING: tracked tracked=foo
    do_stuff(y) # $ MISSING: tracked

def dunder_dict_immediate_read():
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked tracked=foo
    y = x.__dict__["foo"] # $ tracked=foo MISSING: tracked
    do_stuff(y) # $ MISSING: tracked

def dunder_dict_indirect_write():
    attr = "foo"
    x = SomeClass() # $ MISSING: tracked=foo
    x.__dict__[attr] = tracked # $tracked MISSING: tracked=foo
    y = x.foo # $ MISSING: tracked tracked=foo
    do_stuff(y) # $ MISSING: tracked

def dunder_dict_indirect_read():
    attr = "foo"
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked tracked=foo
    y = x.__dict__[attr] # $ tracked=foo MISSING: tracked
    do_stuff(y) # $ MISSING: tracked


