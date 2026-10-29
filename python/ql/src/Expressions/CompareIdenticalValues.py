
#Using 'x == x' to check that 'x' is not a float('nan').
def is_normal(f):
    return not cmath.isinf(f) and f == f

#Improved version; intention is explicit.
def is_normal(f):
    return not cmath.isinf(f) and not cmath.isnan(f)