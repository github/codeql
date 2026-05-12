# Match-statement pattern bindings.

def f(subject):  # $ cfgdefines=f
    match subject:
        case x:  # $ MISSING: cfgdefines=x
            pass
        case [a, b]:  # $ MISSING: cfgdefines=a MISSING: cfgdefines=b
            pass
        case {"k": v}:  # $ MISSING: cfgdefines=v
            pass
        case Point(p, q):  # $ MISSING: cfgdefines=p MISSING: cfgdefines=q
            pass
        case [_, *rest]:  # $ MISSING: cfgdefines=rest
            pass
        case (1 | 2) as n:  # $ MISSING: cfgdefines=n
            pass


class Point:  # $ cfgdefines=Point
    __match_args__ = ("x", "y")  # $ cfgdefines=__match_args__
    x: int  # $ cfgdefines=x
    y: int  # $ cfgdefines=y

