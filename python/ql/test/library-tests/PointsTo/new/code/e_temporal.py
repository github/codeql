
import sys

def f():
    len(sys.argv) >  3 # Should be defined, as call to f() precedes import of sys.
    #The return is completely unconditional, so we can safely infer that calls to f() return 1.
    return 1

def g(arg):
    return arg

x = g(f())
