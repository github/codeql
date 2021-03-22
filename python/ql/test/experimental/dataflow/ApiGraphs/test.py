import a1 #$ use=moduleImport("a1")

x = a1.blah1 #$ use=moduleImport("a1").getMember("blah1")

import a2 as m2 #$ use=moduleImport("a2")

x2 = m2.blah2 #$ use=moduleImport("a2").getMember("blah2")

import a3.b3 as m3 #$ use=moduleImport("a3").getMember("b3")

x3 = m3.blah3 #$  use=moduleImport("a3").getMember("b3").getMember("blah3")

from a4.b4 import c4 as m4 #$ use=moduleImport("a4").getMember("b4").getMember("c4")

x4 = m4.blah4 #$ use=moduleImport("a4").getMember("b4").getMember("c4").getMember("blah4")

import a.b.c.d #$ use=moduleImport("a")

ab = a.b #$ use=moduleImport("a").getMember("b")

abc = ab.c #$ use=moduleImport("a").getMember("b").getMember("c")

abcd = abc.d #$ use=moduleImport("a").getMember("b").getMember("c").getMember("d")

x5 = abcd.method() #$ use=moduleImport("a").getMember("b").getMember("c").getMember("d").getMember("method").getReturn()

from a6 import m6 #$ use=moduleImport("a6").getMember("m6")

x6 = m6().foo().bar() #$ use=moduleImport("a6").getMember("m6").getReturn().getMember("foo").getReturn().getMember("bar").getReturn()

import foo.baz.baz as fbb #$ use=moduleImport("foo").getMember("baz").getMember("baz")
from foo.bar.baz import quux as fbbq #$ use=moduleImport("foo").getMember("bar").getMember("baz").getMember("quux")
from ham.bar.eggs import spam as hbes #$ use=moduleImport("ham").getMember("bar").getMember("eggs").getMember("spam")
fbb.quux #$ use=moduleImport("foo").getMember("baz").getMember("baz").getMember("quux")
fbbq #$ use=moduleImport("foo").getMember("bar").getMember("baz").getMember("quux")
hbes #$ use=moduleImport("ham").getMember("bar").getMember("eggs").getMember("spam")

import foo.bar.baz #$ use=moduleImport("foo")

# Relative imports. These are ignored

from .foo import bar

from ..foobar import baz


# Use of imports across scopes

def use_m4():
    x = m4.blah4 #$ use=moduleImport("a4").getMember("b4").getMember("c4").getMember("blah4")

def local_import_use():
    from foo import bar #$ use=moduleImport("foo").getMember("bar")

    x = bar() #$ use=moduleImport("foo").getMember("bar").getReturn()

from eggs import ham as spam #$ use=moduleImport("eggs").getMember("ham")

def bbb():
    f = spam #$ use=moduleImport("eggs").getMember("ham")

from danger import SOURCE #$ use=moduleImport("danger").getMember("SOURCE")

foo = SOURCE #$ use=moduleImport("danger").getMember("SOURCE")

def change_foo():
    global foo
    foo = SOURCE #$ use=moduleImport("danger").getMember("SOURCE")

def f():
    global foo
    sink(foo) #$ use=moduleImport("danger").getMember("SOURCE")
    foo = NONSOURCE
    change_foo()
    sink(foo) #$ use=moduleImport("danger").getMember("SOURCE")

# Star imports

from unknown import * #$ use=moduleImport("unknown")

hello() #$ MISSING: use=moduleImport("unknown").getMember("hello").getReturn()


# Subclasses

from flask.views import View #$ use=moduleImport("flask").getMember("views").getMember("View")

class MyView(View): #$ use=moduleImport("flask").getMember("views").getMember("View").getASubclass()
    myvar = 45 #$ use=moduleImport("flask").getMember("views").getMember("View").getASubclass().getMember("myvar")
    def my_method(self): #$ use=moduleImport("flask").getMember("views").getMember("View").getASubclass().getMember("my_method")
        pass

instance = MyView() #$ use=moduleImport("flask").getMember("views").getMember("View").getASubclass().getReturn()

def internal():
    from pflask.views import View #$ use=moduleImport("pflask").getMember("views").getMember("View")
    class IntMyView(View): #$ use=moduleImport("pflask").getMember("views").getMember("View").getASubclass()
        my_internal_var = 35 #$ use=moduleImport("pflask").getMember("views").getMember("View").getASubclass().getMember("my_internal_var")
        def my_internal_method(self): #$ use=moduleImport("pflask").getMember("views").getMember("View").getASubclass().getMember("my_internal_method")
            pass

    int_instance = IntMyView() #$ use=moduleImport("pflask").getMember("views").getMember("View").getASubclass().getReturn()


# Built-ins

def use_of_builtins():
    for x in range(5): #$ use=moduleImport("builtins").getMember("range").getReturn()
        if x < len([]): #$ use=moduleImport("builtins").getMember("len").getReturn()
            print("Hello") #$ use=moduleImport("builtins").getMember("print").getReturn()
            raise Exception("Farewell") #$ use=moduleImport("builtins").getMember("Exception").getReturn()

def imported_builtins():
    import builtins #$ use=moduleImport("builtins")
    def open(f):
        return builtins.open(f) #$ MISSING: use=moduleImport("builtins").getMember("open").getReturn()

def redefine_print():
    def my_print(x):
        import builtins #$ use=moduleImport("builtins")
        builtins.print("I'm printing", x) #$ use=moduleImport("builtins").getMember("print").getReturn()
    print = my_print
    print("these words")

def local_redefine_range():
    range = 5
    return range

def global_redefine_range():
    global range
    range = 6
    return range #$ SPURIOUS: use=moduleImport("builtins").getMember("range")

def obscured_print():
    p = print #$ use=moduleImport("builtins").getMember("print")
    p("Can you see me?") #$ use=moduleImport("builtins").getMember("print").getReturn()

def python2_style():
    # In Python 3, `__builtin__` has no special meaning.
    from __builtin__ import open #$ use=moduleImport("__builtin__").getMember("open")
    open("hello.txt") #$ use=moduleImport("__builtin__").getMember("open").getReturn()
