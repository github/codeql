
#Written in Java or C style
def gcd(a, b):
    while(a != 0 and b != 0):
        if(a > b):
            a = a % b
        else:
            b = b % a
    if(a == 0):
        return (b)
    return (a)

#Written in a more Pythonic style
def gcd(a, b):
    while a != 0 and b != 0:
        if a > b:
            a = a % b
        else:
            b = b % a
    if a == 0:
        return b
    return a

