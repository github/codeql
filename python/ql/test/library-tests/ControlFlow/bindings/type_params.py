# PEP 695 type parameters (Python 3.12+).

def func[T](x: T) -> T:  # $ cfgdefines=func cfgdefines=x MISSING: cfgdefines=T
    return x


class Box[T]:  # $ cfgdefines=Box MISSING: cfgdefines=T
    item: T  # $ cfgdefines=item


# Multi-parameter, with bound and variadics.
def multi[T: int, *Ts, **P](x: T, *args: *Ts, **kwargs: P.kwargs) -> T:  # $ cfgdefines=multi cfgdefines=x cfgdefines=args cfgdefines=kwargs MISSING: cfgdefines=T MISSING: cfgdefines=Ts MISSING: cfgdefines=P
    return x


# `type` statement (PEP 695).
type Alias[T] = list[T]  # $ MISSING: cfgdefines=Alias MISSING: cfgdefines=T

