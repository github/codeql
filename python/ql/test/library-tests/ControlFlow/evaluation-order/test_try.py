"""Exception handling control flow: try/except/else/finally evaluation order."""

from timer import test


# 1. try/except — no exception raised (except block skipped)
@test
def test_try_no_exception(t):
    try:
        x = 1 @ t[0]
        y = 2 @ t[1]
    except ValueError:
        z = 3 @ t.dead[2]
    after = 0 @ t[2]


# 2. try/except — exception raised and caught
@test
def test_try_with_exception(t):
    try:
        x = 1 @ t[0]
        raise ((ValueError @ t[1])() @ t[2])
        y = 2 @ t.never
    except ValueError:
        z = 3 @ t[3]
    after = 0 @ t[4]


# 3. try/except/else — no exception (else runs)
@test
def test_try_except_else_no_exception(t):
    try:
        x = 1 @ t[0]
    except ValueError:
        y = 2 @ t.dead[1]
    else:
        z = 3 @ t[1]
    after = 0 @ t[2]


# 4. try/except/else — exception raised (else skipped)
@test
def test_try_except_else_with_exception(t):
    try:
        x = 1 @ t[0]
        raise ((ValueError @ t[1])() @ t[2])
    except ValueError:
        y = 2 @ t[3]
    else:
        z = 3 @ t.dead[3]
    after = 0 @ t[4]


# 5. try/finally — no exception
@test
def test_try_finally_no_exception(t):
    try:
        x = 1 @ t[0]
        y = 2 @ t[1]
    finally:
        z = 3 @ t[2]
    after = 0 @ t[3]


# 6. try/finally — exception raised (finally runs, then exception propagates)
@test
def test_try_finally_exception(t):
    try:
        try:
            x = 1 @ t[0]
            raise ((ValueError @ t[1])() @ t[2])
        finally:
            y = 2 @ t[3]
    except ValueError:
        z = 3 @ t[4]


# 7. try/except/finally — no exception
@test
def test_try_except_finally_no_exception(t):
    try:
        x = 1 @ t[0]
    except ValueError:
        y = 2 @ t.dead[1]
    finally:
        z = 3 @ t[1]
    after = 0 @ t[2]


# 8. try/except/finally — exception caught
@test
def test_try_except_finally_exception(t):
    try:
        x = 1 @ t[0]
        raise ((ValueError @ t[1])() @ t[2])
    except ValueError:
        y = 2 @ t[3]
    finally:
        z = 3 @ t[4]
    after = 0 @ t[5]


# 9. Multiple except clauses — first matching
@test
def test_multiple_except_first(t):
    try:
        x = 1 @ t[0]
        raise ((ValueError @ t[1])() @ t[2])
    except ValueError:
        y = 2 @ t[3]
    except TypeError:
        z = 3 @ t.dead[3]
    after = 0 @ t[4]


# 10. Multiple except clauses — second matching
@test
def test_multiple_except_second(t):
    try:
        x = 1 @ t[0]
        raise ((TypeError @ t[1])() @ t[2])
    except ValueError:
        y = 2 @ t.dead[3]
    except TypeError:
        z = 3 @ t[3]
    after = 0 @ t[4]


# 11. except with `as` binding
@test
def test_except_as_binding(t):
    try:
        x = 1 @ t[0]
        raise ((ValueError @ t[1])("msg" @ t[2]) @ t[3])
    except ValueError as e:
        y = (str @ t[4])(e @ t[5]) @ t[6]
    after = 0 @ t[7]


# 12. Nested try/except
@test
def test_nested_try_except(t):
    try:
        x = 1 @ t[0]
        try:
            y = 2 @ t[1]
            raise ((ValueError @ t[2])() @ t[3])
        except ValueError:
            z = 3 @ t[4]
        w = 4 @ t[5]
    except TypeError:
        v = 5 @ t.dead[6]
    after = 0 @ t[6]


# 13. try/except in a loop
@test
def test_try_in_loop(t):
    total = 0 @ t[0]
    for i in (range @ t[1])(3 @ t[2]) @ t[3]:
        try:
            if (i @ t[4, 11, 20] == 1 @ t[5, 12, 21]) @ t[6, 13, 22]:
                raise ((ValueError @ t[14])() @ t[15])
            total = (total @ t[7, 23] + 1 @ t[8, 24]) @ t[9, 25]
        except ValueError:
            total = (total @ t[16] + 10 @ t[17]) @ t[18]
        r = 0 @ t[10, 19, 26]


# 14. Re-raise with bare `raise`
@test
def test_reraise(t):
    try:
        try:
            x = 1 @ t[0]
            raise ((ValueError @ t[1])() @ t[2])
        except ValueError:
            y = 2 @ t[3]
            raise
    except ValueError:
        z = 3 @ t[4]
    after = 0 @ t[5]
