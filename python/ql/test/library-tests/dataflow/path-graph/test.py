def assign():
    x = SOURCE # $ path-node

    y = x # $ path-node

    SINK(y) # $ path-node


def aug_assign():
    x = SOURCE # $ path-node
    z = ""

    z += x # $ path-node

    SINK(z) # $ path-node


def dont_use_rhs(cond):
    # like noted in the original Ruby PR: https://github.com/github/codeql/pull/12566
    x = SOURCE # $ path-node

    if cond:
        y = x

    SINK(x) # $ path-node


def flow_through_function():
    def identify(x): # $ path-node
        return x # $ path-node

    x = SOURCE # $ path-node

    y = identify(x) # $ path-node

    SINK(y) # $ path-node


def attribute():
    class X: pass
    x = X()
    x.attr = SOURCE # $ path-node

    y = x # $ path-node

    SINK(y.attr) # $ path-node


def list_loop():
    x = SOURCE # $ path-node
    l = list()

    l.append(x) # $ path-node

    for y in l: # $ path-node

        SINK(y) # $ path-node


def list_index():
    x = SOURCE # $ path-node
    l = list()

    l.append(x) # $ path-node

    z = l[0] # $ path-node

    SINK(z) # $ path-node


def test_tuple():
    x = SOURCE # $ path-node

    y = ((x, 1), 2) # $ path-node

    (z, _), _ = y # $ path-node

    SINK(z) # $ path-node


def test_with():
    x = SOURCE # $ path-node

    with x as y: # $ path-node

        SINK(y) # $ path-node


def test_match():
    x = SOURCE # $ path-node

    match x:

        case y: # $ path-node

            SINK(y) # $ path-node
