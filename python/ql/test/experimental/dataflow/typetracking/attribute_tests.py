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
