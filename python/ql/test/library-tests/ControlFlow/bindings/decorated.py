# Decorated `def`/`class` — wired in the new CFG.


def deco(f):  # $ cfgdefines=deco
    return f


@deco
def decorated_func():  # $ cfgdefines=decorated_func
    pass


@deco
class DecoratedClass:  # $ cfgdefines=DecoratedClass
    pass


# Stacked decorators.
@deco
@deco
def doubly():  # $ cfgdefines=doubly
    pass


# Inside a class body.
class Outer:  # $ cfgdefines=Outer
    @staticmethod
    def inner():  # $ cfgdefines=inner
        pass

