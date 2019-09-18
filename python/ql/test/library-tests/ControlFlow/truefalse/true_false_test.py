
def func():
    if cond1:
        true1
    if cond2:
        pass
    else:
        false2
    if cond3:
        true3
    else:
        false3
    try:
        if cond4:
            true4()
        else:
            false4()
    finally:
        pass
    if cond5:
        try:
            true5()
        except:
            pass
    else:
        false5
    if cond6:
        if cond7:
            true7
        else:
            false7
    else:
        false6
    if cond8:
        for i in range(10):
            pass
    else:
        false8
    if cond9:
        while cond10:
            true10
        false10
    else:
        false9
    while 1:
        if cond12:
            try:
                true12()
            except IOError:
                true12 = 0



def func2():
    while condw1:
        truew2

def func3():
    if condi1:
        truei1

def func4():
    while True:
        no_branch
    if unreachable:
        not reachable

def func5():
    while True:
        break
    if cond11:
        true11

def func6():
    if cond13 or cond13a:
        true13
    if cond14 and cond14a:
        true14
    true15 if cond15 else false15
    true16 if cond16 or cond17 else false16
    true18 if cond18 and cond19 else false18

def func7():
    yield cond20 or cond21 or cond22
    yield cond23 and cond24 and cond25
