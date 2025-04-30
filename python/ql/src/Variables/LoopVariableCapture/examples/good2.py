import functools
# GOOD: `functools.partial` takes care of capturing the _value_ of `i`.
tasks = []
for i in range(5):
    tasks.append(functools.partial(lambda i: print(i), i))

# This will print `0,1,2,3,4``.
for t in tasks:
    t() 