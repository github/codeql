# PEP 695 type parameters (Python 3.12+).

def func[T](x: T) -> T:  # $ cfgdefines=func cfgdefines=x cfgdefines=T
    return x


class Box[T]:  # $ cfgdefines=Box cfgdefines=T
    item: T  # $ cfgdefines=item


# Multi-parameter, with bound and variadics.
def multi[T: int, *Ts, **P](x: T, *args: *Ts, **kwargs: P.kwargs) -> T:  # $ cfgdefines=multi cfgdefines=x cfgdefines=args cfgdefines=kwargs cfgdefines=T cfgdefines=Ts cfgdefines=P
    return x


# `type` statement (PEP 695).
type Alias[T] = list[T]  # $ cfgdefines=Alias cfgdefines=T

