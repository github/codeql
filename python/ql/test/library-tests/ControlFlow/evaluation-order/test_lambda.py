"""Lambda expressions — evaluation order."""

from timer import test


@test
def test_simple_lambda(t):
    """Lambda creates a function object in one step."""
    f = (lambda x: (x @ t[3] + 1 @ t[4]) @ t[5]) @ t[0]
    result = (f @ t[1])(10 @ t[2]) @ t[6]


@test
def test_lambda_multiple_args(t):
    """Lambda call: arguments evaluate left to right."""
    f = (lambda a, b, c: ((a @ t[5] + b @ t[6]) @ t[7] + c @ t[8]) @ t[9]) @ t[0]
    result = (f @ t[1])(1 @ t[2], 2 @ t[3], 3 @ t[4]) @ t[10]


@test
def test_lambda_default(t):
    """Default argument evaluated at lambda creation time."""
    val = 5 @ t[0]
    f = (lambda x, y=val @ t[1]: (x @ t[5] + y @ t[6]) @ t[7]) @ t[2]
    result = (f @ t[3])(10 @ t[4]) @ t[8]


@test
def test_lambda_map(t):
    """Lambda body runs once per element when consumed by list(map(...))."""
    f = (lambda x: (x @ t[9, 12, 15] * 2 @ t[10, 13, 16]) @ t[11, 14, 17]) @ t[0]
    result = (list @ t[1])((map @ t[2])(f @ t[3], [1 @ t[4], 2 @ t[5], 3 @ t[6]] @ t[7]) @ t[8]) @ t[18]


@test
def test_immediately_invoked(t):
    """Arguments evaluated, then immediately-invoked lambda called."""
    result = ((lambda x: (x @ t[2] + 1 @ t[3]) @ t[4]) @ t[0])(10 @ t[1]) @ t[5]


@test
def test_lambda_closure(t):
    """Lambda captures enclosing scope; body runs at call time."""
    x = 10 @ t[0]
    f = (lambda: x @ t[3]) @ t[1]
    result = (f @ t[2])() @ t[4]
