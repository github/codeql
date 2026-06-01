# Basic SSA tests for the new-CFG SSA adapter.
#
# The shared SSA implementation prunes its construction by liveness:
# definitions of variables that are not read are never materialised.
# This is by design — write-only variables would only bloat the SSA
# graph. Tests therefore must always include a read of each variable
# being verified.
#
# Annotations:
#   def=<var>: there is an SSA write definition of <var> at this line
#   use=<var>: <var> is used here and the read resolves to some def
#
# Note: a module-level `def name(...)` statement is itself a write
# definition of the module global `name`, which is live (it can be read
# externally), so every function below carries a `def=<name>` annotation
# on its `def` line.


def basic_param(x):  # $ def=basic_param def=x
    return x  # $ use=x


def basic_assign():  # $ def=basic_assign
    y = 1  # $ def=y
    return y  # $ use=y


def reassignment():  # $ def=reassignment
    x = 1
    x = 2  # $ def=x
    return x  # $ use=x


def if_else_phi(cond):  # $ def=if_else_phi def=cond
    if cond:  # $ use=cond phi=x
        x = 1  # $ def=x
    else:
        x = 2  # $ def=x
    return x  # $ use=x


# `some_undefined` is never assigned anywhere, so (matching legacy ESSA)
# the SSA library creates no entry definition for it: an undefined-name
# read resolves to no SSA def, hence there is no `use=` here.
def use_global():  # $ def=use_global
    return some_undefined


