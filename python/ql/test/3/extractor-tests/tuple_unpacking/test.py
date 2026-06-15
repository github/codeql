def cons(x, ys):
    return x, *ys

def cons_each(xs, ys):
    for x in xs:
        yield x, *ys

print(cons(1,(2,3,4)))

for l in cons_each((1,2),(3,4)):
    print(l)
