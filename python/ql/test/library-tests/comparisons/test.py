
def simple_tests(x):
    if x == 4:
        pass
    if x != 4:
        pass
    if x > 4:
        pass
    if x < 4:
        pass
    if x >= 4:
        pass
    if x <= 4:
        pass

def f(w, x, y, z):
    if x < 0 or z < 0:
        raise Exception()
    if x >= 0: # Useless test due to x < 0 being false
        y += 1
    if z >= 0: # Useless test due to z < 0 being false 
        y += 1
    while w >= 0:
        if y < 7:
            z += 1
            if y == 15: # Useless test due to y < 10 being true
                z += 1
        elif y > 10:
            y -= 1
    if y < 10:
        y += 1
        if y < 12: #A useless test, but too complex to infer.
            pass
    if (not
        y != 5 and 
        z > 0):
        w = 0 if y < 3 else 1 #Useless test as y is 5

def simple_tests2(x, y):
    if x == y+4:
        pass
    if x != y+4:
        pass
    if x > y+4:
        pass
    if x < y+4:
        pass
    if x >= y+4:
        pass
    if x <= y+4:
        pass

def g(w, x, y, z):
    if (w < x or 
        y < z+2):
        raise Exception()
    if w >= x: # Useless test due to w < x being false
        pass
    if z > y-2: # Useless test due to y < z+2 being false 
        y += 1

#Complex things we can't analyse
def h(a,b,c,d):
    if a < b - g(c):
        pass
    if a(c) < b(d):
        pass
    if a < 10 + b + c:
        pass
    if a > 20 - g(c):
        pass
    if a + 10 > g(c):
        pass


#ODASA-5643
def validate_series(start, end):
    if end < start:
        raise error()
    if start == end:
        raise error()
    return start, end

def big1(x, y):
    if x + 10000000000000000 > y + 10000000000000001:
        return
    if x > y:
        # Redundant (but cannot be sure due to FP rounding errors)
        pass

def big2(x, y):
    if x + 10000000000000000 > y + 10000000000000001:
        return
    if x > y:
        # Not redundant (but might appear to be due to FP rounding errors)
        pass
