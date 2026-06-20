"""If/elif/else control flow evaluation order."""

from timer import test, dead


@test
def test_if_true(t):
    x = True @ t[0]
    if x @ t[1]:
        y = 1 @ t[2]
    z = 0 @ t[3]


@test
def test_if_false(t):
    x = False @ t[0]
    if x @ t[1]:
        y = 1 @ t[dead(2)]
    z = 0 @ t[2]


@test
def test_if_else_true(t):
    x = True @ t[0]
    if x @ t[1]:
        y = 1 @ t[2]
    else:
        y = 2 @ t[dead(2)]
    z = 0 @ t[3]


@test
def test_if_else_false(t):
    x = False @ t[0]
    if x @ t[1]:
        y = 1 @ t[dead(2)]
    else:
        y = 2 @ t[2]
    z = 0 @ t[3]


@test
def test_if_elif_else_first(t):
    x = 1 @ t[0]
    if (x @ t[1] == 1 @ t[2]) @ t[3]:
        y = "first" @ t[4]
    elif (x @ t[dead(4)] == 2 @ t[dead(5)]) @ t[dead(6)]:
        y = "second" @ t[dead(4)]
    else:
        y = "third" @ t[dead(4)]
    z = 0 @ t[5]


@test
def test_if_elif_else_second(t):
    x = 2 @ t[0]
    if (x @ t[1] == 1 @ t[2]) @ t[3]:
        y = "first" @ t[dead(7)]
    elif (x @ t[4] == 2 @ t[5]) @ t[6]:
        y = "second" @ t[7]
    else:
        y = "third" @ t[dead(7)]
    z = 0 @ t[8]


@test
def test_if_elif_else_third(t):
    x = 3 @ t[0]
    if (x @ t[1] == 1 @ t[2]) @ t[3]:
        y = "first" @ t[dead(7)]
    elif (x @ t[4] == 2 @ t[5]) @ t[6]:
        y = "second" @ t[dead(7)]
    else:
        y = "third" @ t[7]
    z = 0 @ t[8]


@test
def test_nested_if_else(t):
    x = True @ t[0]
    y = True @ t[1]
    if x @ t[2]:
        if y @ t[3]:
            z = 1 @ t[4]
        else:
            z = 2 @ t[dead(4)]
    else:
        z = 3 @ t[dead(4)]
    w = 0 @ t[5]


@test
def test_if_compound_condition(t):
    x = True @ t[0]
    y = False @ t[1]
    if (x @ t[2] and y @ t[3]) @ t[4]:
        z = 1 @ t[dead(5)]
    else:
        z = 2 @ t[5]
    w = 0 @ t[6]


@test
def test_if_pass(t):
    x = True @ t[0]
    if x @ t[1]:
        pass
    z = 0 @ t[2]
