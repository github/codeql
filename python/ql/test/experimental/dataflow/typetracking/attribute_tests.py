class SomeClass:
    pass

def simple_read_write():
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked $tracked=foo
    y = x.foo # $tracked=foo $tracked
    do_stuff(y) # $tracked

def foo():
    x = SomeClass() # $tracked=attr
    bar(x) # $tracked=attr
    x.attr = tracked # $tracked=attr $tracked
    baz(x) # $tracked=attr

def bar(x): # $tracked=attr
    z = x.attr # $tracked $tracked=attr
    do_stuff(z) # $tracked

def expects_int(x): # $int=field $f+:str=field
    do_int_stuff(x.field) # $int $f+:str $int=field $f+:str=field

def expects_string(x): # $f+:int=field $str=field
    do_string_stuff(x.field) # $f+:int $str $f+:int=field $str=field

def test_incompatible_types():
    x = SomeClass() # $int,str=field
    x.field = int(5) # $int=field $f+:str=field $int $f+:str
    expects_int(x) # $int=field $f+:str=field
    x.field = str("Hello") # $f+:int=field $str=field $f+:int $str
    expects_string(x) # $f+:int=field $str=field


# Attributes assigned statically to a class

class MyClass: # $tracked=field
    field = tracked # $tracked

lookup = MyClass.field # $tracked $tracked=field
instance = MyClass() # $tracked=field
lookup2 = instance.field # $f-:tracked

## Dynamic attribute access

# Via `getattr`/`setattr`

def setattr_immediate_write():
    x = SomeClass() # $tracked=foo
    setattr(x,"foo", tracked) # $tracked $tracked=foo
    y = x.foo # $tracked $tracked=foo
    do_stuff(y) # $tracked

def getattr_immediate_read():
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked $tracked=foo
    y = getattr(x,"foo") # $tracked $tracked=foo
    do_stuff(y) # $tracked

def setattr_indirect_write():
    attr = "foo"
    x = SomeClass() # $tracked=foo
    setattr(x, attr, tracked) # $tracked $tracked=foo
    y = x.foo # $tracked $tracked=foo
    do_stuff(y) # $tracked

def getattr_indirect_read():
    attr = "foo"
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked $tracked=foo
    y = getattr(x, attr) #$tracked $tracked=foo
    do_stuff(y) # $tracked

# Via `__dict__` -- not currently implemented.

def dunder_dict_immediate_write():
    x = SomeClass() # $f-:tracked=foo
    x.__dict__["foo"] = tracked # $tracked $f-:tracked=foo
    y = x.foo # $f-:tracked $f-:tracked=foo
    do_stuff(y) # $f-:tracked

def dunder_dict_immediate_read():
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked $tracked=foo
    y = x.__dict__["foo"] # $f-:tracked $tracked=foo
    do_stuff(y) # $f-:tracked

def dunder_dict_indirect_write():
    attr = "foo"
    x = SomeClass() # $f-:tracked=foo
    x.__dict__[attr] = tracked # $tracked $f-:tracked=foo
    y = x.foo # $f-:tracked $f-:tracked=foo
    do_stuff(y) # $f-:tracked

def dunder_dict_indirect_read():
    attr = "foo"
    x = SomeClass() # $tracked=foo
    x.foo = tracked # $tracked $tracked=foo
    y = x.__dict__[attr] # $f-:tracked $tracked=foo
    do_stuff(y) # $f-:tracked


