# test of other content types than attributes

def test_tuple(index_arg):
    tup = (tracked, other) # $tracked

    tup[0] # $ tracked
    tup[1]

    a,b = tup # $tracked
    a # $ tracked
    b

    # non-precise access is not supported right now (and it's not 100% clear if we want
    # to support it, or if it will lead to bad results)
    tup[index_arg]

    for x in tup:
        print(x)

    for i in range(len(tup)):
        print(tup[i])


def test_dict(key_arg):
    d1 = {"t": tracked, "o": other} # $tracked
    d1["t"] # $ tracked
    d1.get("t") # $ MISSING: tracked
    d1.setdefault("t") # $ MISSING: tracked

    d1["o"]
    d1.get("o")
    d1.setdefault("o")


    # non-precise access is not supported right now (and it's not 100% clear if we want
    # to support it, or if it will lead to bad results)
    d1[key_arg]

    for k in d1:
        d1[k]

    for v in d1.values():
        v

    for k, v in d1.items():
        v


    # construction with inline updates
    d2 = dict()
    d2["t"] = tracked # $ tracked
    d2["o"] = other

    d2["t"] # $ tracked
    d2["o"]

    # notice that time-travel is also possible (just as with attributes)
    d3 = dict()
    d3["t"] # $ SPURIOUS: tracked
    d3["t"] = tracked # $ tracked
    d3["t"] # $ tracked


def test_list(index_arg):
    l = [tracked, other] # $tracked

    l[0] # $ MISSING: tracked
    l[1]

    # non-precise access is not supported right now (and it's not 100% clear if we want
    # to support it, or if it will lead to bad results)
    l[index_arg]

    for x in l:
        print(x)

    for i in range(len(l)):
        print(l[i])
