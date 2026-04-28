"""Ternary conditional expressions and evaluation order."""

from timer import test, dead


@test
def test_ternary_true(t):
    # Condition is True — consequent evaluated, alternative skipped
    x = (1 @ t[1] if True @ t[0] else 2 @ t[dead(1)]) @ t[2]


@test
def test_ternary_false(t):
    # Condition is False — alternative evaluated, consequent skipped
    x = (1 @ t[dead(1)] if False @ t[0] else 2 @ t[1]) @ t[2]


@test
def test_ternary_nested(t):
    # Nested: outer condition True, inner condition True
    # ((10 if C1 else 20) if C2 else 30) — C2 first, then C1, then 10
    x = ((10 @ t[2] if True @ t[1] else 20 @ t[dead(2)]) @ t[3] if True @ t[0] else 30 @ t[dead(1)]) @ t[4]


@test
def test_ternary_assignment(t):
    # Ternary result assigned, then used in later expression
    value = (100 @ t[1] if True @ t[0] else 200 @ t[dead(1)]) @ t[2]
    result = (value @ t[3] + 1 @ t[4]) @ t[5]


@test
def test_ternary_complex_expressions(t):
    # Complex sub-expressions in condition and consequent
    x = ((1 @ t[3] + 2 @ t[4]) @ t[5] if (3 @ t[0] > 2 @ t[1]) @ t[2] else (4 @ t[dead(3)] + 5 @ t[dead(4)]) @ t[dead(5)]) @ t[6]


@test
def test_ternary_as_argument(t):
    # Ternary used as a function argument
    def f(a):
        return a @ t[4]

    result = (f @ t[0])((1 @ t[2] if True @ t[1] else 2 @ t[dead(2)]) @ t[3]) @ t[5]
