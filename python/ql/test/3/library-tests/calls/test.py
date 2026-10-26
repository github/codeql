#Multi-version


a(1, 2, *[3,4])
b(**{'b': 2, 'd': 4})
c(1, *x, a=y, **p)
d(a=1,**y)

#Python 3.5 only

print(*[1], *[2], 3, *[4, 5])
fn(**{'a': 1, 'c': 3}, **{'b': 2, 'd': 4})
g(1, *x, 2, a=y, *z, b=3, **p)
h(**x,a=1,**y)
