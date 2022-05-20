# invalid class with return outside a function
class InvalidClass1(object):
    if [1, 2, 3]:
        return "Exists"

# invalid statement with yield outside a function
for i in [1, 2, 3]:
    yield i
