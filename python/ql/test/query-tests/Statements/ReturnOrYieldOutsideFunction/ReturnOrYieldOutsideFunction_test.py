# valid class with return inside a function
class ValidClass1(object):
    def class_method(self):
        return False

# valid class with yield inside a function
class ValidClass2(object):
    def class_method(self):
        yield 1

# valid class with yield from inside a function
class ValidClass3(object):
    def class_method(self):
        yield from [1, 2]

# valid function with the return statement
def valid_func1():
    return True

# valid function with the yield statement
def valid_func2():
    yield 1

# valid function with the yield from statement
def valid_func3():
    yield from [1, 2]

# invalid class with return outside a function
class InvalidClass1(object):
    if [1, 2, 3]:
        return "Exists" # $ Alert

# invalid class with yield outside a function
class InvalidClass2(object):
    while True:
        yield 1 # $ Alert

# invalid class with yield from outside a function
class InvalidClass3(object):
    while True:
        yield from [1, 2] # $ Alert

# invalid statement with return outside a function
for i in [1, 2, 3]:
    return i # $ Alert

# invalid statement with yield outside a function
for i in [1, 2, 3]:
    yield i # $ Alert

# invalid statement with yield from outside a function
for i in [1, 2, 3]:
    yield from i # $ Alert

# invalid statement with yield from outside a function
var = [1,2,3]
yield from var # $ Alert

# invalid statement with return outside a function
return False # $ Alert

# invalid statement with yield outside a function
yield False # $ Alert