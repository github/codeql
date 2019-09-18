

def f(w, x, y, z):
    if x < 0 or z < 0:
        raise Exception()
    if x >= 0: # Useless test due to x < 0 being false
        y += 1
    if z >= 0: # Useless test due to z < 0 being false 
        y += 1
    while w >= 0:
        if y < 10:
            z += 1
            if y == 15: # Useless test due to y < 10 being true
                z += 1
        elif y > 7: # Useless test 
            y -= 1
    if y < 10:
        y += 1
        if y < 12: #A useless test, but too complex to infer.
            pass
    if not y != 5 and z > 0:
        w = 0 if y < 3 else 1 #Useless test as y is 5

def g(w, x, y, z):
    if w < x or y < z+2:
        raise Exception()
    if w >= x: # Useless test due to w < x being false
        pass
    if cond:
        if z > y-2: # Useless test due to y < z+2 being false 
            y += 1
    else:
        if z >= y-2: # Not a useless test.
            y += 1

#ODASA-5643
def validate_series(start, end):
    # Check that the values 'make sense'
    if end < start:
        raise click.BadParameter('The start value must be less than the end value.')
    if start == end:
        raise click.BadParameter('The start value and the end value most not be the same.')
    return start, end

#Overflow
def medium1(x, y):
    if x + 1000000000000000 > y + 1000000000000000:
        return
    if x > y: # Redundant
        pass

def medium2(x, y):
    if x + 1000000000000000 > y + 1000000000000001:
        return
    if x > y: # Not redundant
        pass

def big1(x, y):
    if x + 10000000000000000 > y + 10000000000000000:
        return
    if x > y: # Redundant (but cannot be sure due to FP rounding errors)
        pass

def big2(x, y):
    if x + 10000000000000000 > y + 10000000000000001:
        return
    if x > y: # Not redundant (but might appear to be due to FP rounding errors)
        pass

def odasa6782_v1(protocol):
    if protocol < 0:
        protocol = HIGHEST_PROTOCOL
    elif not 0 <= protocol:
        raise ValueError()

def odasa6782_v2(protocol):
    if protocol < 0:
        protocol = HIGHEST_PROTOCOL
    elif not 0 <= protocol <= HIGHEST_PROTOCOL:
        raise ValueError()

def odasa6782_v3(protocol):
    if protocol < 0:
        protocol = HIGHEST_PROTOCOL
    elif 0 <= protocol <= HIGHEST_PROTOCOL:
        pass
    else:
        raise ValueError()

#Inverted complex test
if not (0 > stop >= step) and stop < 0:
    pass

