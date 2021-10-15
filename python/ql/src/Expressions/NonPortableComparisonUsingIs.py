
CONSTANT = 12

def equals_to_twelve(x):
    return x is CONSTANT

#This works in CPython, but might not for other implementations.
print (equals_to_twelve(5 + 7))
