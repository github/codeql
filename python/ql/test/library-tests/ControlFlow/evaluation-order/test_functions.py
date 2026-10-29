"""Function calls and definitions — evaluation order."""

from timer import test


@test
def test_argument_order(t):
    """Arguments evaluate left-to-right before the call."""
    def add(a, b):
        return (a @ t[3] + b @ t[4]) @ t[5]
    result = (add @ t[0])(1 @ t[1], 2 @ t[2]) @ t[6]


@test
def test_multiple_arguments(t):
    """All arguments left-to-right, then the call."""
    def f(a, b, c):
        return ((a @ t[4] + b @ t[5]) @ t[6] + c @ t[7]) @ t[8]
    result = (f @ t[0])(1 @ t[1], 2 @ t[2], 3 @ t[3]) @ t[9]


@test
def test_default_arguments(t):
    """Default expressions are evaluated at definition time."""
    val = 5 @ t[0]
    def f(a, b=val @ t[1]):
        return (a @ t[4] + b @ t[5]) @ t[6]
    result = (f @ t[2])(10 @ t[3]) @ t[7]


@test
def test_args_kwargs(t):
    """*args and **kwargs — expressions evaluated before the call."""
    def f(*args, **kwargs):
        return ((sum @ t[9])(args @ t[10]) @ t[11] + (sum @ t[12])(((kwargs @ t[13]).values @ t[14])() @ t[15]) @ t[16]) @ t[17]
    args = [1 @ t[0], 2 @ t[1]] @ t[2]
    kwargs = {"c" @ t[3]: 3 @ t[4]} @ t[5]
    result = (f @ t[6])(*args @ t[7], **kwargs @ t[8]) @ t[18]


@test
def test_nested_calls(t):
    """Inner call completes before becoming an argument to outer call."""
    def f(x):
        return (x @ t[7] + 1 @ t[8]) @ t[9]
    def g(x):
        return (x @ t[3] * 2 @ t[4]) @ t[5]
    result = (f @ t[0])((g @ t[1])(1 @ t[2]) @ t[6]) @ t[10]


@test
def test_function_as_argument(t):
    """Function object is just another argument, evaluated left-to-right."""
    def apply(fn, x):
        return (fn @ t[3])(x @ t[4]) @ t[8]
    def double(x):
        return (x @ t[5] * 2 @ t[6]) @ t[7]
    result = (apply @ t[0])(double @ t[1], 5 @ t[2]) @ t[9]


@test
def test_decorator(t):
    """Decorator: expression evaluated, function defined, decorator called."""
    def my_decorator(fn):
        return fn @ t[1]
    @(my_decorator @ t[0])
    def f():
        return 42 @ t[3]
    result = (f @ t[2])() @ t[4]


@test
def test_keyword_arguments(t):
    """Keyword argument values evaluate left-to-right."""
    def f(a, b):
        return (a @ t[3] + b @ t[4]) @ t[5]
    result = (f @ t[0])(a=1 @ t[1], b=2 @ t[2]) @ t[6]


@test
def test_return_value(t):
    """The return value is just the result of the call expression."""
    def f(x):
        return (x @ t[2] * 2 @ t[3]) @ t[4]
    result = (f @ t[0])(3 @ t[1]) @ t[5]
