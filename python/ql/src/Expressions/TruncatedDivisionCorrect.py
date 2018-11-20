# Correct:
from __future__ import division

def average(l):
    return sum(l) / len(l)

print average([1.0, 2.0])  # Prints "1.5".
print average([1, 2])      # Prints "1.5".
