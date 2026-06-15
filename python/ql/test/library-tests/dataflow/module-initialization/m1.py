# constant
foo = 42

import base

def passOn(x):
    return x

# depends on other constant
bar = passOn(base.foo)
