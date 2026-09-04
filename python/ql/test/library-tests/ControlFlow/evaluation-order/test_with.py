"""Evaluation order tests for with statements."""

from contextlib import contextmanager
from timer import test


@contextmanager
def ctx(value=None):
    yield value


@test
def test_simple_with(t):
    x = 1 @ t[0]
    with (ctx @ t[1])() @ t[2]:
        y = 2 @ t[3]
    z = 3 @ t[4]


@test
def test_with_as(t):
    with (ctx @ t[0])(42 @ t[1]) @ t[2] as v:
        x = v @ t[3]
    y = 0 @ t[4]


@test
def test_nested_with(t):
    with (ctx @ t[0])() @ t[1]:
        with (ctx @ t[2])() @ t[3]:
            x = 1 @ t[4]
    y = 2 @ t[5]


@test
def test_multiple_context_managers(t):
    with (ctx @ t[0])(1 @ t[1]) @ t[2] as a, (ctx @ t[3])(2 @ t[4]) @ t[5] as b:
        x = (a @ t[6], b @ t[7]) @ t[8]
    y = 0 @ t[9]


@test
def test_with_exception_handling(t):
    try:
        with (ctx @ t[0])() @ t[1]:
            x = 1 @ t[2]
            raise ((ValueError @ t[3])() @ t[4])
    except ValueError:
        y = 2 @ t[5]
    z = 3 @ t[6]


@test
def test_with_in_loop(t):
    for i in [1 @ t[0], 2 @ t[1]] @ t[2]:
        with (ctx @ t[3, 6])() @ t[4, 7]:
            x = i @ t[5, 8]
    y = 0 @ t[9]
