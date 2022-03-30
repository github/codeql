# No
import mod
def no():
    a
    a.b
    1+p
    b"Hi"
    u"Hi"
    [x]
    {}
    x,y
    s[9]
    f()
    f(a,b)
    o.m()
    o.m(a, b)
    o.m[0]
    x()[0]
    yield v
    [1 for a in b]
    {x for x in z}
    {x:y for x,y in z}

#Yes
def yes():
    (a)
    (a.b)
    (1+p)
    (b"Hi")
    (u"Hi")
    ([x])
    ({})
    (x,y)
    (s[9])
    (f())
    (f(a,b))
    (o.m())
    (o.m(a, b))
    (o.m[0])
    (x()[0])
    (yield 1)
    ([1 for a in b])
    ({x for x in z})
    ({x:y for x,y in z})
    (b"x")
    ("x"+1)
    (1+f())
    (1+2+f())
    ("Failed to parse template " + name + ": " + repr(ex))
    (1+2+3+4)
    (1+2+3+4+5)
    (1+2+3+4+5+6)

def multiline():
    ( 1 + 
       ( 2 * 3
        * 4 )
    )

    (
    x,
    1, 
    "a"
    )
