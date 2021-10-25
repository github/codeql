#Ensure there is an exceptional edge from the following case






def f2():
    b, d = Base, Derived
    try:
        class MyNewClass(b, d):
            pass
    except:
        e2

def f3():
    sequence_of_four = a_global
    try:
        a, b, c = sequence_of_four
    except:
        e3

#Always treat locals as non-raising to keep DB size down.
def f4():
    if cond:
        local = 1
    try:
        local
    except:
        e4

def f5():
    try:
        a_global
    except:
        e5

def f6():
    local = a_global
    try:
        local()
    except:
        e6

#Literals can't raise
def f7():
    try:
        4
    except:
        e7

def f8():
    try:
        a + b
    except:
        e8


#OK assignments
def f9():
    try:
        a, b = 1, 2
    except:
        e9

def fa():
    seq = a_global
    try:
        a = seq
    except:
        ea

def fb():
    a, b, c = a_global
    try:
        seq = a, b, c
    except:
        eb

#Ensure that a.b and c[d] can raise

def fc():
    a, b = a_global
    try:
        return a[b]
    except:
        ec

def fd():
    a = a_global
    try:
        return a.b
    except:
        ed
        

def fe():
    try:
        call()
    except:
        ee
    else:
        ef

    

