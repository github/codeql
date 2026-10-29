# Reachability of code following a try whose body always returns.
#
# The new CFG models exception edges for raise-prone expressions when
# they appear inside a `try` (or `with`) statement, mirroring Java's
# `mayThrow`. This means the body of a `try` has both a normal
# completion edge and an exception edge to its handlers, so code
# following the try-statement is reachable via the except-handler path
# even when the try-body would otherwise always return.
#
# Code that is not reachable under either normal or exception flow
# (for example, the `else` clause of a try whose body unconditionally
# raises) remains correctly classified as dead.


def f(obj):  # $ cfgdefines=f cfgdefines=obj
    try:
        return len(obj)
    except TypeError:
        pass

    # The try-body always returns, but `len(obj)` can raise (it is
    # inside the try, so we model its exception edge). The
    # `except TypeError: pass` handler falls through to here, making
    # the code below reachable.
    try:
        hint = type(obj).__length_hint__  # $ cfgdefines=hint
    except AttributeError:
        return None
    return hint


def g():  # $ cfgdefines=g
    try:
        raise Exception("inner")
    except:
        raise Exception("outer")
    else:
        # Unreachable: the inner try body always raises (via an explicit
        # `raise`, which is modelled unconditionally), so the `else:`
        # clause never runs.
        hit_inner_else = True


def h(cache, key):  # $ cfgdefines=h cfgdefines=cache cfgdefines=key
    try:
        return cache[key]
    except KeyError:
        pass

    # Same pattern as `f`: reachable via the except-handler fall-through.
    value = compute(key)  # $ cfgdefines=value
    cache[key] = value
    return value
