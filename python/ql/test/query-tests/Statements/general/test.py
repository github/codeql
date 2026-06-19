




def break_in_finally(seq, x):
    for i in seq:
        try:
            x()
        finally:
            break # $ Alert[py/exit-from-finally]
    return 0

def return_in_finally(seq, x):
    for i in seq:
        try:
            x()
        finally:
            return 1 # $ Alert[py/exit-from-finally]
    return 0

#Break in loop in finally
#This is OK
def return_in_loop_in_finally(f, seq):
    try:
        f()
    finally:
        for i in seq:
            break

#But this is not
def return_in_loop_in_finally(f, seq):
    try:
        f()
    finally:
        for i in seq:
            return # $ Alert[py/exit-from-finally]

def unnecessary_pass(arg):
    print (arg)
    pass # $ Alert[py/unnecessary-pass]

#Non-iterator in for loop

class NonIterator(object):

    def __init__(self):
        pass

for x in NonIterator():
    do_something(x)

#None in for loop

def dodgy_iter(x):
    if x:
        s = None
    else:
        s = [0,1]
    #Error -- Could be None
    for i in s:
        print(i)
    #Ok Test for None
    if s:
        for i in s:
            print(i)
    if s is not None:
        for i in s:
            print(i)

#OK to iterate over:
class GetItem(object):

    def __getitem__(self, i):
        return i

for y in GetItem():
    pass

class D(dict): pass

for z in D():
    pass












def modification_of_locals():
    x = 0
    locals()['x'] = 1 # $ Alert[py/modification-of-locals]
    l = locals()
    l.update({'x':1, 'y':2}) # $ Alert[py/modification-of-locals]
    l.pop('y') # $ Alert[py/modification-of-locals]
    del l['x'] # $ Alert[py/modification-of-locals]
    l.clear() # $ Alert[py/modification-of-locals]
    return x


globals()['foo'] = 42 # OK
# in module-level scope `locals() == globals()`
# FP report from https://github.com/github/codeql/issues/6674
locals()['foo'] = 43 # technically OK


#C-style things

if (cond): # $ Alert[py/c-style-parentheses]
    pass

while (cond): # $ Alert[py/c-style-parentheses]
    pass

assert (test) # $ Alert[py/c-style-parentheses]

def parens(x):
    return (x) # $ Alert[py/c-style-parentheses]


#ODASA-2038
class classproperty(object):

    def __init__(self, getter):
        self.getter = getter

    def __get__(self, instance, instance_type):
        return self.getter(instance_type)

class WithClassProperty(object):

    @classproperty
    def x(self):
        return [0]

wcp = WithClassProperty()

for i in wcp.x:
    assert x == 0
for i in WithClassProperty.x:
    assert x == 0

#Should use context mamager

class CM(object):

    def __enter__(self):
        pass

    def __exit__(self, ex, cls, tb):
        pass

    def write(self, data):
        pass

def no_with():
    f = CM()
    try:
        f.write("Hello ")
        f.write(" World\n")
    finally:
        f.close() # $ Alert[py/should-use-with]

# Should not use a 'with' statement here: the resource is held in an instance
# attribute, so its lifetime spans the enclosing instance and cannot be expressed
# with a 'with' statement. Instance-attribute type tracking can launder the
# instance out of the field, but this must not be reported.
class HoldsCM(object):

    def __init__(self):
        self.f = CM()

    def no_with_attribute(self):
        try:
            self.f.write("Hello ")
            self.f.write(" World\n")
        finally:
            self.f.close()  # No alert: re-exposes a field, not a local resource.

#Assert without side-effect
def assert_ok(seq):
    assert all(isinstance(element, (str, unicode)) for element in seq)

# False positive. ODASA-8042. Fixed in PR #2401.
class false_positive:
    e = (x for x in [])

# In class-level scope `locals()` reflects the class namespace,
# so modifications do take effect.
class MyClass:
    locals()['x'] = 43  # OK
    y = x


# Once a `locals()` dictionary is passed out of the scope that created it, it is
# just an ordinary mapping. Modifying it in a different scope is meaningful and
# effective, so these modifications must NOT be flagged: the "no effect on local
# variables" gotcha only applies within the scope that called `locals()`.
def modify_passed_dict(ns):
    ns['k'] = 1  # OK: `ns` is a parameter here, not this scope's locals()
    ns.update({'j': 2})  # OK
    ns.pop('k')  # OK
    del ns['j']  # OK
    ns.clear()  # OK


def pass_locals_to_function():
    y = 1
    modify_passed_dict(locals())
    return y


# The same situation, but where the `locals()` dictionary is laundered through an
# instance attribute (as instance-attribute type tracking now models). These must
# also not be flagged.
class NamespaceHolder(object):

    def __init__(self, ns):
        self.ns = ns

    def populate(self):
        self.ns['extra'] = 1  # OK: different scope from the `locals()` call
        self.ns.update({'more': 2})  # OK


def launder_locals_through_instance():
    x = 1
    holder = NamespaceHolder(locals())
    holder.populate()
    return x
