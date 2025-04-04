import functools
# GOOD: A default parameter is used, so the variable `i` is not being captured.
tasks = []
for i in range(5):
    tasks.append(functools.partial(lambda i: print(i), i))

# This will print `0,1,2,3,4``.
for t in tasks:
    t() 