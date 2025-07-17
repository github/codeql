
#Make a list of functions to increment their arguments by 0 to 9.
def make_incrementers():
    result = []
    for i in range(10):
        def incrementer(x, i=i):
            return x + i
        result.append(incrementer)
    return result

#This will pass
def test():
    incs = make_incrementers()
    for x in range(10):
        for y in range(10):
            assert incs[x](y) == x+y

test()