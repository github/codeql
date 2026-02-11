# Computing the Euclidian norm using the Pythagorean Theorem

from math import sqrt

def withPow(a, b):
    return sqrt(a**2 + b**2) # $ Alert

def withMul(a, b):
    return sqrt(a*a + b*b) # $ Alert

def withRef(a, b):
    a2 = a**2
    b2 = b*b
    return sqrt(a2 + b2) # $ Alert