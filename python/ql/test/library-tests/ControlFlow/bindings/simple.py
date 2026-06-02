# Simple bindings that should already work in the new CFG.
# No MISSING annotations expected.

x = 1  # $ cfgdefines=x
y = x + 1  # $ cfgdefines=y

def f():  # $ cfgdefines=f
    pass

class C:  # $ cfgdefines=C
    pass

# Re-assignment.
x = 2  # $ cfgdefines=x
