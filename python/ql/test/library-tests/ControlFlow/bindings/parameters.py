# Function parameters.

def positional(a, b):  # $ cfgdefines=positional cfgdefines=a cfgdefines=b
    pass


def with_default(x=1, y=2):  # $ cfgdefines=with_default cfgdefines=x cfgdefines=y
    pass


def with_vararg(*args):  # $ cfgdefines=with_vararg cfgdefines=args
    pass


def with_kwarg(**kwargs):  # $ cfgdefines=with_kwarg cfgdefines=kwargs
    pass


def with_kwonly(*, k1, k2=5):  # $ cfgdefines=with_kwonly cfgdefines=k1 cfgdefines=k2
    pass


def kitchen_sink(a, b=2, *args, k1, k2=5, **kw):  # $ cfgdefines=kitchen_sink cfgdefines=a cfgdefines=b cfgdefines=args cfgdefines=k1 cfgdefines=k2 cfgdefines=kw
    pass


# Methods get `self` / `cls`.
class C:  # $ cfgdefines=C
    def method(self, x):  # $ cfgdefines=method cfgdefines=self cfgdefines=x
        pass

    @classmethod
    def cmethod(cls, x):  # $ cfgdefines=cmethod cfgdefines=cls cfgdefines=x
        pass


# Lambda parameter.
_ = lambda p: p + 1  # $ cfgdefines=_ cfgdefines=p

# PEP 570 positional-only.
def pos_only(a, b, /, c):  # $ cfgdefines=pos_only cfgdefines=a cfgdefines=b cfgdefines=c
    pass
