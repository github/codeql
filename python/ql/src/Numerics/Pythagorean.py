# We know that a^2 + b^2 = c^2, and wish to use this to compute c
from math import sqrt, hypot

a = 3e154 # a^2 > 1e308
b = 4e154 # b^2 > 1e308
# with these, c = 5e154 which is less that 1e308

def longSideDirect():
    return sqrt(a**2 + b**2) # this will overflow

def longSideBuiltin():
    return hypot(a, b) # better to use built-in function