### Tests of global flow

# Simple assignment

g = [5] # $writes=g

# Multiple assignment

g1, g2 = [6], [7] # $writes=g1 writes=g2

# Assignment that's only referenced in this scope. This one will not give rise to a `ModuleVariableNode`.

unreferenced_g = [8]
print(unreferenced_g)

# Testing modifications of globals

# Modification by reassignment

g_mod = []
# This assignment does not produce any flow, since `g_mod` is immediately reassigned.

# The following assignment should not be a `ModuleVariableNode`,
# but currently our analysis thinks `g_mod` might be used in the `print` call
g_mod = [10] # $ SPURIOUS: writes=g_mod
print("foo")
g_mod = [100] # $writes=g_mod

# Modification by mutation

g_ins = [50] # $writes=g_ins
print(g_ins)
g_ins.append(75)

# A global with multiple potential definitions

import unknown_module
if unknown_module.attr:
    g_mult = [200] # $writes=g_mult
else:
    g_mult = [300] # $writes=g_mult

# A global variable that may be redefined depending on some unknown value

g_redef = [400] # $writes=g_redef
if unknown_module.attr:
    g_redef = [500] # $writes=g_redef

def global_access():
    l = 5
    print(g) # $reads=g
    print(g1) # $reads=g1
    print(g2) # $reads=g2
    print(g_mod) # $reads=g_mod
    print(g_ins) # $reads=g_ins
    print(g_mult) # $reads=g_mult
    print(g_redef) # $reads=g_redef

def print_g_mod(): # $writes=print_g_mod
    print(g_mod) # $reads=g_mod

def global_mod():
    global g_mod
    g_mod += [150] # $reads,writes=g_mod
    print_g_mod() # $reads=print_g_mod

def global_inside_local_function():
    def local_function():
        print(g) # $reads=g
    local_function()

## Imports


# Direct imports

import foo_module # $writes=foo_module

def use_foo():
    print(foo_module.attr) # $reads=foo_module

# Partial imports

from bar import baz_attr, quux_attr # $writes=baz_attr writes=quux_attr

def use_partial_import():
    print(baz_attr, quux_attr) # $reads=baz_attr reads=quux_attr

# Aliased imports

from spam_module import ham_attr as eggs_attr # $writes=eggs_attr

def use_aliased_import():
    print(eggs_attr) # $reads=eggs_attr

# Import star (unlikely to work unless we happen to extract/model the referenced module)

# Unknown modules

from unknown import *

def secretly_use_unknown():
    print(unknown_attr) # $reads=unknown_attr

# Known modules

from known import *

def secretly_use_known():
    print(known_attr) # $reads=known_attr

# Local import in function

def imports_locally():
    import mod1

# Global import hidden in function

def imports_stuff():
    global mod2
    import mod2 # $writes=mod2
