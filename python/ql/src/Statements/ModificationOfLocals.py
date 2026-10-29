
def modifies_locals_sum(x, y):
    locals()['z'] = x + y
    #z will not be defined as modifications to locals() do not alter the local variables.
    return z

def fixed_sum(x, y):
    z = x + y
    return z

