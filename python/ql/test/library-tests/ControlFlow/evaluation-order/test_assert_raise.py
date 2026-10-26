"""Assert and raise statement evaluation order."""

from timer import test, dead


@test
def test_assert_true(t):
    x = True @ t[0]
    assert x @ t[1]
    y = 1 @ t[2]


@test
def test_assert_true_with_message(t):
    x = True @ t[0]
    assert x @ t[1], "msg" @ t[dead(2)]
    y = 1 @ t[2]


@test
def test_assert_false_caught(t):
    try:
        x = False @ t[0]
        assert x @ t[1], "fail" @ t[2]
    except AssertionError:
        y = 1 @ t[3]


@test
def test_raise_caught(t):
    try:
        x = 1 @ t[0]
        raise ((ValueError @ t[1])("test" @ t[2]) @ t[3])
    except ValueError:
        y = 2 @ t[4]


@test
def test_raise_from_caught(t):
    try:
        x = 1 @ t[0]
        raise ((ValueError @ t[1])("test" @ t[2]) @ t[3]) from ((RuntimeError @ t[4])("cause" @ t[5]) @ t[6])
    except ValueError:
        y = 2 @ t[7]


@test
def test_bare_reraise(t):
    try:
        try:
            raise ((ValueError @ t[0])("test" @ t[1]) @ t[2])
        except ValueError:
            x = 1 @ t[3]
            raise
    except ValueError:
        y = 2 @ t[4]
