# Points-to information seems to be missing if our analysis thinks the enclosing function
# is never called. However, as illustrated by the code below, it's easy to fool our
# analysis :(

# This was inspired by a problem in real code, where our analysis doesn't have any
# points-to information about the `open` call in
# https://google-gruyere.appspot.com/code/gruyere.py on line 227

def _func_not_called(filename, mode='rb'):
    check(open)
    return open(filename, mode)

def _func_called(filename, mode='rb'):
    check(open)
    return open(filename, mode)

globals()['_func_not_called']('test.txt')
_func_called('test.txt')
