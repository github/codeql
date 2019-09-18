
def split1(cond):
    if cond:
        pass
    if cond:
        pass

def dont_split1(cond):
    if cond:
        pass
    cond = f()
    if cond:
        pass

def dont_split2(cond):
    if cond:
        pass
    for cond in seq: pass
    if cond:
        pass


def split2():
    try:
        call()
        x = True
    except:
        x = False
    if x:
        pass

def unclear_split3():
    try: # May be arguably better to split here.
        call()
        x = True
    except:
        x = False
    if cond: # Currently split here 
        x = False
    if x:
        pass

def split4(x):
    if x is None:
        x = not_none()
    c if b else c
    return x

def split_carefully_5(x):
    if x is None:
        x = not_none()
    if x:
        pass
    return x


def dont_split_globals():
    if cond:
        pass
    call_could_alter_any_global()
    if cond:
        pass

def limit_splitting1(a,b,c,d):
    if a is None: a = "a"
    if b is None: b = "b"
    if c is None: c = "c"
    if d is None: d = "d"
    pass







def limit_splitting2(a,b,c,d):
    if a:
        pass
    if b:
        pass
    if c:
        pass
    if d:
        pass
    #These should be pruned
    if a:
        a1
    if b:
        b1
    #But not these
    if c:
        c1
    if d:
        d1

def split_on_numbers():
    try:
        call()
        x = -1
    except:
        x = 0
    if x:
        pass

def split_try_except_else():
    try:
        call()
    except:
        x = 0
    else:
        x = 1
    if x:
        pass

#Example taken from logging module
#Splitting should allow us to deduce that module2 is defined at point of use
def logging():
    try:
        import module1
        import module2

    except ImportError:
        module1 = None

    if module1:
        inst = module2.Class()

#Handle 'not' as well.
def split5():
    try:
        call()
        x = True
    except:
        x = False
    if not x:
        pass

def split6():
    try:
        call()
        x = True
    except:
        x = False
    if not not x:
        pass

def split7():
    try:
        call()
        x = not True
    except:
        x = not False
    if x:
        pass

def split8(cond):
    if cond:
        t = True
    else:
        t = False
    if not cond:
        if t:
            pass


def split9(var):
    if var is None:
        a1
    else:
        a2
    if var is not None:
        b1
    else:
        b2

def split10(var):
    if var:
        a1
    else:
        a2
    if var is not None:
        b1
    else:
        b2

def split11(var):
    if var is None:
        a1
    else:
        a2
    if var:
        b1
    else:
        b2

def dont_split_on_unrelated_variables(var1, var2):
    if var1 is None:
        a1
    else:
        a2
    if var2 is not None:
        b1
    else:
        b2

def split12():
    try:
        call()
        x = None
    except:
        import x
    if x:
        pass

def split13():
    var = cond()
    if var:
        a1
    else:
        a2
    try:
        b1
    finally:
        if var:
            a3


def split14():
    flag = False
    try:
        x = something()
    except Exception:
        99
        flag = True
    if not flag:
        #Should be split here
        pass

def split15(var):
    if var:
        other = 0
    if not var or other.attr:  #other looks like it might be undefined, but it is defined.
        pass

def split16():
    x = True
    if cond:
        x = None
    if x:
        use(x)

def dont_split_on_different_ssa(var):
    if var:
        a1
    else:
        a2
    var = func()
    if var is not None:
        b1
    else:
        b2

def split17(var):
    #Should only be split once
    if var:
        a1
    else:
        a2
    if not var:
        b1
    else:
        b2
    if var:
        c1
    else:
        c2
    if var:
        d1
    else:
        d2
    if var:
        e1
    else:
        e2

def split18(var):
    #Should only be split once
    if var:
        a1
    else:
        a2
    if var is not None:  #Distinguishes between False and None
        b1
    else:
        b2
    if var is None:
        c1
    else:
        c2
    if var:
        d1
    else:
        d2
    if var:
        e1
    else:
        e2

def split_on_boolean_only(x):
    if x:
        a1
    else:
        a2
    if x is not None:
        b1
    else:
        b2
    if x:
        c1
    else:
        c2

def split_on_none_aswell(x):
    if x:
        a1
    else:
        a2
    if x is not None:
        b1
    else:
        b2
    if x is None:
        c1
    else:
        c2

def split_on_or_defn(var):
    if var:
        obj = thing()
    if not var or obj.attr: # obj is defined if reached
        x

def split_on_exception():
    flag = False
    try:
        x = do_something()
    except Exception:
        flag = True
    if not flag:
        x # x is defined here

def partially_useful_split(cond):
    if cond:
        x = None
    else:
        x = something_or_none()
    other_stuff()
    if x:
        a1
    else:
        a2

def dont_split_not_useful(cond, y):
    if cond:
        x = None
    else:
        x = something_or_none()
    other_stuff()
    if y:
        a1
    else:
        a2

#Splittings with boolean expressions:
def f(x,y):
    if x and y:
        raise
    if not (x or y):
        raise
    pass

def g(x,y):
    if x and y:
        raise
    if x or y:
        # Either x or y is true here (exclusive).
        here
    end

def h(x, y):
    if (
        (x and
         not y) or
        (x and
         y.meth())
        ):
        pass

def j(a, b):
    if a or b:
        if a:
            here
        else:
            there

def split_on_strings():
    try:
        might_fail()
        x = "yes+"
    except:
        x = "no"
    #We want to split here, even though we can't (easily) prune
    if x == "no":
        pass
    pass


def scipy_stylee(x):
    assert x in ("a", "b", "c")
    if x == "a":
        pass
    elif x == "b":
        pass
    elif x == "c":
        pass
    else:
        #unreachable
        pass

def odasa_6674(x):
    valid = True
    if dont_understand_this():
        try:
            may_raise()
            score = 0
        except KeyError:
            valid = False
        if not valid:
            raise ValueError()
    else:
        score = 1
    return score

def odasa_6625(k):
    value = "hi"
    if k.endswith('_min') or k.endswith('_max'):
        value = 0
    if k == 'tags':
        return value + " there"


def avoid_redundant_split(a):
    if a: # Should split here
        x = unknown_thing()
    else:
        x = None
    if x: # but not here,
        pass
    if x: # or here, because
        pass
    other_stuff()
    try: # we want to split here
        import foo
        var = True
    except:
        var = False
    if var:
        foo.bar()


