"""Unpacking and star expressions evaluation order."""

from timer import test


@test
def test_tuple_unpack(t):
    """RHS expression evaluates, then unpacking assigns targets."""
    a, b = (1 @ t[0], 2 @ t[1]) @ t[2]
    x = (a @ t[3] + b @ t[4]) @ t[5]


@test
def test_list_unpack(t):
    """List unpacking: RHS elements left to right, then unpack."""
    [a, b] = [1 @ t[0], 2 @ t[1]] @ t[2]
    x = (a @ t[3] + b @ t[4]) @ t[5]


@test
def test_star_unpack(t):
    """Star unpacking: RHS evaluates first."""
    a, *b = [1 @ t[0], 2 @ t[1], 3 @ t[2], 4 @ t[3]] @ t[4]
    x = (a @ t[5], b @ t[6]) @ t[7]


@test
def test_nested_unpack(t):
    """Nested unpacking: RHS evaluates first."""
    (a, b), c = ((1 @ t[0], 2 @ t[1]) @ t[2], 3 @ t[3]) @ t[4]
    x = ((a @ t[5] + b @ t[6]) @ t[7] + c @ t[8]) @ t[9]


@test
def test_swap(t):
    a = 1 @ t[0]
    b = 2 @ t[1]
    a, b = (b @ t[2], a @ t[3]) @ t[4]
    x = a @ t[5]
    y = b @ t[6]


@test
def test_unpack_for(t):
    pairs = [(1 @ t[0], 2 @ t[1]) @ t[2], (3 @ t[3], 4 @ t[4]) @ t[5]] @ t[6]
    for a, b in pairs @ t[7]:
        x = a @ t[8, 10]
        y = b @ t[9, 11]
