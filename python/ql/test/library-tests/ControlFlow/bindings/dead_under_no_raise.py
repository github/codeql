# Dead bindings under the "no expressions raise" CFG abstraction.
#
# The new CFG does not currently model raise edges from arbitrary
# expressions. As a consequence, code that is only reachable through
# exception flow is (correctly) classified as dead and has no CFG node.
# Variable bindings in dead code do not need CFG nodes - SSA / dataflow
# over dead code is moot.
#
# These tests act as a regression guard: the bindings below intentionally
# have no `cfgdefines=` annotations. If raise modelling is later added,
# the BindingsTest infrastructure will surface the new CFG nodes as
# unexpected results, and this file will need to be revisited.


def f(obj):  # $ cfgdefines=f cfgdefines=obj
    try:
        return len(obj)
    except TypeError:
        pass

    # The first try's body always returns; its except handler does not
    # raise or otherwise transfer control, so under "no expressions
    # raise" the only paths out of the try-statement are dead. Everything
    # below is unreachable.
    try:
        hint = type(obj).__length_hint__
    except AttributeError:
        return None
    return hint


def g():  # $ cfgdefines=g
    try:
        raise Exception("inner")
    except:
        raise Exception("outer")
    else:
        # Unreachable: the inner try body always raises, so the `else:`
        # clause never runs.
        hit_inner_else = True


def h(cache, key):  # $ cfgdefines=h cfgdefines=cache cfgdefines=key
    try:
        return cache[key]
    except KeyError:
        pass

    # Same pattern as `f`: dead under "no expressions raise".
    value = compute(key)
    cache[key] = value
    return value
