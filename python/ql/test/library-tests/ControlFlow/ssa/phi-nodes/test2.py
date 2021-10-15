#Weird formatting is so that all uses and defn are on separate lines
#to assist checking test results.

def with_phi(
    cond):
    if cond:
        l0 = 0
    else:
        l0 = 1
    return l0

def with_phi2(
    cond):
    l1 = 0
    if cond:
        pass
    else:
        l1 = 1
    return l1
