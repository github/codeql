# Match-statement pattern bindings — wired in the new CFG.

def f(subject):  # $ cfgdefines=f cfgdefines=subject
    match subject:
        case x:  # $ cfgdefines=x
            pass
        case [a, b]:  # $ cfgdefines=a cfgdefines=b
            pass
        case {"k": v}:  # $ cfgdefines=v
            pass
        case Point(p, q):  # $ cfgdefines=p cfgdefines=q
            pass
        case [_, *rest]:  # $ cfgdefines=rest
            pass
        case (1 | 2) as n:  # $ cfgdefines=n
            pass


class Point:  # $ cfgdefines=Point
    __match_args__ = ("x", "y")  # $ cfgdefines=__match_args__
    x: int  # $ cfgdefines=x
    y: int  # $ cfgdefines=y


