#Test flow control for augmented assignment statements:

#Parameters
def func1(s, o, x, y, z):
    #Note that the right hand sides should be sufficiently complex
    #to make the parts of the statement sufficiently separated
    x += f(y, (1,2,3))
    o.val.item += f(y, (1,2,3))
    s[z, 10, 1:3] += f(y, (1,2,3))
    return x

#Local variables
def func2():
    s = None
    o = None
    x = None
    y = None
    z = None
    #Note that the right hand sides should be sufficiently complex
    #to make the parts of the statement sufficiently separated
    x += f(y, (1,2,3))
    o.val.item += f(y, (1,2,3))
    s[z, 10, 1:3] += f(y, (1,2,3))
    return x

#Complex flow
def comp(v, cond):
    v += a if cond else b
    return v
