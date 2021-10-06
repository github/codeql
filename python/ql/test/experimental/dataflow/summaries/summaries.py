tainted = identity("taint")
sink(tainted)

tainted2 = apply_lambda(lambda x: x + 1, tainted)
sink(tainted2)

def add_colon(x):
    return x + ":"

tainted3 = map(add_colon, [tainted, tainted2])
sink(tainted3[0])

def explicit_identity(x):
    return x

tainted4 = map(explicit_identity, [tainted, tainted2])
sink(tainted4[0])

tainted5 = map(identity, [tainted, tainted2])
sink(tainted5[0])
