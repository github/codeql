tainted = identity("taint")
sink(tainted)

tainted2 = apply_lambda(lambda x: x + 1, tainted)
sink(tainted2)

def add_colon(x):
    return x + ":"

tainted3 = map(add_colon, [tainted, tainted2])
sink(tainted3[0])
