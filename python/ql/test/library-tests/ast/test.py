
@deco1
@deco2()
@deco3.attr1.attr2
class C(Base):

    def __init__(self):
        pass

@deco4.attr()
def f():
    pass

def f(pos0, pos1, *args, **kwargs):
    pass

def simple_stmts():
    pass
    foo() ; del x; pass
    if thing:
        for a in b:
            pass
    #Expressions
    tmp = (
        yield 3,
        name,
        attr.attrname,
        a + b,
        3 & 4,
        3.0 * 4,
        a.b.c.d,
        a().b[c],
        lambda x: x+1,
        p or q and r ^ s,
        a < b > c in 5,
        { 1 : y for z in x for y in z},
        { (1, y) for z in x for y in z},
        [ y**2 for y in z ],
        [],
        {},
        (),
        (1,),
    )
    foo(1)
    foo(a=1)
    foo(1,2,*t)
    foo(1,a=1,*t)
    foo(1,a=1,*t,**d)
    f(**d)

def compound_stmts():
    if cond:
        return x
    else:
        raise y
    while True:
        if cond:
            break
        else:
            continue
    for x in y:
        pass
    with a as b, c as d:
        body
    try:
        t1
    except:
        e1
    try:
        t2
    except Exception:
        e2
    try:
        t3
    except Exception as ex:
        e3
    try:
        t4
    finally:
        f4
    try:
        t5
    except Exception as ex:
        e5
    finally:
        f5
    try:
        t6
    finally:
        try:
            t7
        finally:
            f7

