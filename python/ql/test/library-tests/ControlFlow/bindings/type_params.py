# PEP 695 type parameters (Python 3.12+).

# PEP 695 type-param names on `def`/`class` bind in an annotation scope
# that nests the function/class body — they have no CFG node in the
# enclosing scope (matching the legacy CFG).
def func[T](x: T) -> T:  # $ cfgdefines=func cfgdefines=x
    return x


class Box[T]:  # $ cfgdefines=Box
    item: T  # $ cfgdefines=item


# Multi-parameter, with bound and variadics.
def multi[T: int, *Ts, **P](x: T, *args: *Ts, **kwargs: P.kwargs) -> T:  # $ cfgdefines=multi cfgdefines=x cfgdefines=args cfgdefines=kwargs
    return x


# `type` statement (PEP 695).
type Alias[T] = list[T]  # $ cfgdefines=Alias cfgdefines=T

