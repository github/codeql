
def bad1():
    results = []
    for x in range(10):
        def inner():
            return x
    results.append(inner)
    return results

a = [lambda: i for i in range(1, 4)]
for f in a:
    print(f())

#OK:
#Using default argument
def good1():
    results = []
    for y in range(10):
        def inner(y=y):
            return y
    results.append(inner)
    return results

#Factory function
l = []
for r in range(10):
    def make_foo(r):
        def foo():
            return r
        return foo
    l.append(make_foo(r))

#The inner function does not escape loop.
def ok1():
    result = 0
    for z in range(10):
        def inner():
            return z
        result += inner()
    return result

b = [lambda: i for i in range(1, 4) for j in range(1,5)]
c = [lambda: j for i in range(1, 4) for j in range(1,5)]

s = {lambda: i for i in range(1, 4)}
for f in s:
    print(f())

d = {i:lambda: i for i in range(1, 4)}
for k, f in d.items():
    print(k, f())

#Generator expressions are sometimes OK, if they evaluate the iteration 
#When the captured variable is used.
#So technically this is a false positive, but it is extremely fragile
#code, so I (Mark) think it is fine to report it as a violation.
g = (lambda: i for i in range(1, 4))
for f in g:
    print(f())

#But not if evaluated eagerly
l = list(lambda: i for i in range(1, 4))
for f in l:
    print(f())

def odasa4860(asset_ids):
    return dict((asset_id, filter(lambda c : c.asset_id == asset_id, xxx)) for asset_id in asset_ids)
