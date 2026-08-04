"""Evaluation order for match/case (structural pattern matching, Python 3.10+)."""

import sys
if sys.version_info < (3, 10):
    print("Skipping match/case tests (requires Python 3.10+)")
    print("---")
    print("0/0 tests passed")
    sys.exit(0)

from timer import test, dead, never


@test
def test_match_literal(t):
    x = 1 @ t[0]
    match x @ t[1]:
        case 1:
            y = "one" @ t[2]
        case 2:
            y = "two" @ t[dead(2)]
    z = y @ t[3]


@test
def test_match_literal_fallthrough(t):
    x = 3 @ t[0]
    match x @ t[1]:
        case 1:
            y = "one" @ t[dead(2)]
        case 2:
            y = "two" @ t[dead(2)]
        case 3:
            y = "three" @ t[2]
    z = y @ t[3]


@test
def test_match_wildcard(t):
    x = 42 @ t[0]
    match x @ t[1]:
        case 1:
            y = "one" @ t[dead(2)]
        case _:
            y = "other" @ t[2]
    z = y @ t[3]


@test
def test_match_capture(t):
    x = 42 @ t[0]
    match x @ t[1]:
        case n:
            y = n @ t[2]
    z = y @ t[3]


@test
def test_match_or_pattern(t):
    x = 2 @ t[0]
    match x @ t[1]:
        case 1 | 2:
            y = "low" @ t[2]
        case _:
            y = "other" @ t[dead(2)]
    z = y @ t[3]


@test
def test_match_guard(t):
    x = 5 @ t[0]
    match x @ t[1]:
        case n if (n @ t[2] > 3 @ t[3]) @ t[4]:
            y = n @ t[5]
        case _:
            y = 0 @ t[dead(5)]
    z = y @ t[6]


@test
def test_match_class_pattern(t):
    x = 42 @ t[0]
    match x @ t[1]:
        case int():
            y = "integer" @ t[2]
        case str():
            y = "string" @ t[dead(2)]
    z = y @ t[3]


@test
def test_match_sequence(t):
    x = [1 @ t[0], 2 @ t[1]] @ t[2]
    match x @ t[3]:
        case [a, b]:
            y = (a @ t[4] + b @ t[5]) @ t[6]
        case _:
            y = 0 @ t[dead(6)]
    z = y @ t[7]


@test
def test_match_mapping(t):
    x = {"key" @ t[0]: 42 @ t[1]} @ t[2]
    match x @ t[3]:
        case {"key": value}:
            y = value @ t[4]
        case _:
            y = 0 @ t[dead(4)]
    z = y @ t[5]


@test
def test_match_nested(t):
    x = {"users" @ t[0]: [{"name" @ t[1]: "Alice" @ t[2]} @ t[3]] @ t[4]} @ t[5]
    match x @ t[6]:
        case {"users": [{"name": name}]}:
            y = name @ t[7]
        case _:
            y = "unknown" @ t[dead(7)]
    z = y @ t[8]


@test
def test_match_or_pattern_with_as(t):
    """OR pattern with `as` binding and method call on the result."""
    clause = "foo@bar" @ t[0]
    match clause @ t[1]:
        case (str() as uses) | {"uses": uses}:
            result = ((uses @ t[2]).partition @ t[3])("@" @ t[4]) @ t[5]
            x = (result @ t[6])[0 @ t[7]] @ t[8]
        case _:
            raise ((ValueError @ t[dead(2)])(clause @ t[dead(3)]) @ t[dead(4)])
    y = x @ t[9]


@test
def test_match_wildcard_raise(t):
    """Wildcard case that raises, with OR pattern on the other branch."""
    clause = 42 @ t[0]
    try:
        match clause @ t[1]:
            case (str() as uses) | {"uses": uses}:
                result = uses @ t[dead(2)]
            case _:
                raise ((ValueError @ t[2])(f"Invalid: {clause @ t[3]}" @ t[4]) @ t[5])
    except ValueError:
        y = 0 @ t[6]


@test
def test_match_exhaustive_return_first(t):
    """Every case returns; code after match is unreachable (first case taken)."""
    def f(x):
        match x @ t[2]:
            case 1:
                return "one" @ t[3]
            case _:
                return "other" @ t[dead(3)]
        y = 0 @ t[never]
    result = (f @ t[0])(1 @ t[1]) @ t[4]


@test
def test_match_exhaustive_return_wildcard(t):
    """Every case returns; code after match is unreachable (wildcard taken)."""
    def f(x):
        match x @ t[2]:
            case 1:
                return "one" @ t[dead(3)]
            case _:
                return "other" @ t[3]
        y = 0 @ t[never]
    result = (f @ t[0])(99 @ t[1]) @ t[4]
