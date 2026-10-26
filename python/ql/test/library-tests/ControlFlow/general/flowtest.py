def definitions(p1): # Multiple defns of same variable
    v1 = 0
    v1
    v1 = 1
    v1
    v2 = 2
    if p1:
        v1 = 1
        v2 = 2
    else:
        v2 = 2
    v1
    v2

def lloop(): #Loop
    v3 = 0
    while 1:
        v3

def gloop(): #Loop and global
    global d1
    d1 = 0
    g1
    while g2:
        g3

def deletion():
    global g4
    del g4
    g5
    v4 = 0
    del v4
    v4

def if_else():
    if cond1:
        left
    else:
        right
    merged

def try_except():
    try:
        try_body1()
        try_body2()
    except ExceptionL if cond2 else ExceptionR:
        except_handler
    fall_through1

def try_finally():
    try:
        try_body3()
        try_body4()
    finally:
        final_body
    fall_through2

def normal_args(arg0, arg1):
    arg0
    arg1

def special_args(*vararg, **kwarg):
    vararg

    kwarg



#A comment
#at the end of the file



