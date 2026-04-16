"""Short-circuit boolean operators and evaluation order."""

from timer import test


@test
def test_and_both_sides(t):
    # True and X — both operands evaluated, result is X
    x = (True @ t[0] and 42 @ t[1]) @ t[2]


@test
def test_and_short_circuit(t):
    # False and ... — right side never evaluated
    x = (False @ t[0] and True @ t.dead[1]) @ t[1]


@test
def test_or_short_circuit(t):
    # True or ... — right side never evaluated
    x = (True @ t[0] or False @ t.dead[1]) @ t[1]


@test
def test_or_both_sides(t):
    # False or X — both operands evaluated, result is X
    x = (False @ t[0] or 42 @ t[1]) @ t[2]


@test
def test_not(t):
    # not evaluates its operand, then negates
    x = (not True @ t[0]) @ t[1]
    y = (not False @ t[2]) @ t[3]


@test
def test_chained_and(t):
    # 1 and 2 and 3 — all truthy, all evaluated left-to-right
    x = (1 @ t[0] and 2 @ t[1] and 3 @ t[2]) @ t[3]


@test
def test_chained_or(t):
    # 0 or "" or 42 — first two falsy, all evaluated until truthy found
    x = (0 @ t[0] or "" @ t[1] or 42 @ t[2]) @ t[3]


@test
def test_mixed_and_or(t):
    # True and False or 42 => (True and False) or 42 => False or 42 => 42
    x = ((True @ t[0] and False @ t[1]) @ t[2] or 42 @ t[3]) @ t[4]


@test
def test_and_side_effects(t):
    # Both functions called when left side is truthy
    def f():
        return 10 @ t[1]

    def g():
        return 20 @ t[4]

    x = ((f @ t[0])() @ t[2] and (g @ t[3])() @ t[5]) @ t[6]


@test
def test_or_side_effects(t):
    # Both functions called when left side is falsy
    def f():
        return 0 @ t[1]

    def g():
        return 20 @ t[4]

    x = ((f @ t[0])() @ t[2] or (g @ t[3])() @ t[5]) @ t[6]
