# Points-to information seems to be missing if our analysis thinks the enclosing function
# is never called. However, as illustrated by the code below, it's easy to fool our
# analysis :(

# This was inspired by a problem in real code, where our analysis doesn't have any
# points-to information about the `open` call in
# https://google-gruyere.appspot.com/code/gruyere.py on line 227

def some_function():
    print('some_function')

def _ignored():
    print('_ignored')
    some_function() # $ tt=some_function

def _works_since_called():
    print('_works_since_called')
    some_function() # $ pt,tt=some_function

def works_even_though_not_called():
    some_function() # $ pt,tt=some_function

globals()['_ignored']()
_works_since_called() # $ pt,tt=_works_since_called
