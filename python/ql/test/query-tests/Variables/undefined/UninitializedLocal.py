
class C:

    def m1(self):
        y = ug1
        x = 1
        return y

    def m2(self, p):
        return p

    def m3(self, x1):
        return u2
        u2 = x1

    def m4(self, x2):
        if x2:
            u3 = 1
        return u3

def f():
    y = ug1
    x = 1
    return y

def g(x3):
    def h():
        y = x3

def q(x4):
    def h():
        y = x4
        x = 1

def j(u4):
    del u4
    return u4

def k(x5):
    x5 + 1
    del x5

def m(x6):
    if x6:
        u6 = 1
    u6
    #The following are not uninitialized, but unreachable.
    u6
    u6

#ODASA-1897
def l(x7):
    try:
        if f():
            raise Exception
        mod_name = x7[:-3]
        mod = __import__(mod_name)
    except ImportError:
        raise ValueError(mod_name)



def check_del(cond):
    u8 = 1
    if cond:
        del u8
    else:
        pass
    u8
    if cond:
        u9 = 1
        del u9
    else:
        u9 = 2
    u9
    if cond:
        x10 = 1
        del x10
        x10 = 2
    else:
        x10 = 3
    x10
    u11 = 1
    del u11
    u11
    u12 = "hi"
    del u12
    del u12

#x will always be defined.
def const_range():
    for i in range(4):
        x = i
    return x


def asserts_false(cond1, cond2):
    if cond1:
        x13 = 1
    elif cond2:
        x13 = 2
    else:
        assert False, "Can't happen"
    return x13

#Splitting
def use_def_conditional(cond3):
    if cond3:
        x14 = 1
    x15 = 2
    if cond3:
        return x14

def use_def_conditional(cond4, cond5):
    if cond4:
        u14 = 1
    x16 = 2
    if cond5:
        return u14


def init_and_set_flag_in_try(f):
    try:
        f()
        x17 = 1
        success = True
    except:
        success = False
    if success:
        return x17

#Check that we can rely on splitting
def split_OK():
    try:
        f()
        x18 = 1
        cond = not True
    except:
        cond = not False
    if not cond:
        return x18

def split_not_OK():
    try:
        f()
        u19 = 1
        cond = not True
    except:
        cond = not False
    if not not cond:
        return u19

def double_is_none(x):
    if x is not None:
        v = 0
    if x is None:
        return 0
    else:
        return v

#ODASA-4241
def def_in_post_loop(seq):
    j(x)
    x = []
    for p in seq:
        x = p

#Check that we are consistent with both sides of if statement
#ODASA-4615
def f(cond1, cond2):
    if cond1:
        x = 1
    else:
        y = 1
    if cond2:
        return x
    else:
        return y

def needs_splitting(var):
    if var:
        other = 0
    if not var or other:  #other looks like it might be undefined, but it is defined.
        pass

def odasa4867(status):
    fail = (status != 200)
    if not fail:
        1
    if not fail:
        var = 2
    if not fail:
        3
    if not fail and not l(var): # Observed FP - var is defined.
        4
    fail = True   # It is possible that this was interfering with splitting.
    if not fail:  # Not the same SSA variable as earlier
        5

def odasa5896(number):
    guesses_made = 0
    while guesses_made < 6:  # This loop is guaranteed to execute at least once.
        guess = int(input('Take a guess: '))
        guesses_made += 1

    if guess == number: # FP here
        pass

#ODASA 6212
class C(object):

    def fail(self):
        raise Exception()

def may_fail(cond, c):
    if cond:
        x = 0
    else:
        c.fail()
    return x


def deliberate_name_error(cond):
    if cond:
        x = 0
    try:
        x # x is uninitialised, but guarded. So don't report it.
    except NameError:
        x = 1
    return x # x is initialised here, but we would need splitting to know that.


from unknown import x
may_fail(x, C())


def with_definition(x):
    with open(x) as y:
        y

def multiple_defn_in_try(x):
    try:
        for p, q in x:
            p
    except KeyError:
        pass

# ODASA-6742

import sys
class X(object):

    def leave(self, code = 1):
        sys.exit(code)

class Y(object):

    def __init__(self, x):
        self._x = x

    def leave(self):
        self._x.leave()

def odasa6742(cond, obj):
    y = Y(X())
    try:
        var = may_fail(cond, obj)
    except:
        y.leave()
    var


#ODASA-6904
def avoid_redundant_split(a):
    if a: # Should split here
        b = x()
    else:
        b = None
    if b: # but not here,
        pass
    if b: # or here, because
        pass
    pass
    try: # we want to split here
        import foo
        var = True
    except:
        var = False
    if var:
        foo.bar() #foo is defined here.
