import math

def call_with_x_squared(x, function):
    x = x*x
    return function(x)

print call_with_x_squared(2, math.factorial)