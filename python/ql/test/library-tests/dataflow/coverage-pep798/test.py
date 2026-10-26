# PEP 798: Unpacking in comprehensions.
# These desugar to `yield from`, so flow depends on yield-from support.

def test_star_list_comp():
    l = [[SOURCE]]
    flat = [*x for x in l]
    SINK(flat[0]) # $ MISSING:flow="SOURCE, l:-2 -> flat[0]"


def test_star_set_comp():
    l = [[SOURCE]]
    flat = {*x for x in l}
    SINK(flat.pop()) # $ MISSING:flow="SOURCE, l:-2 -> flat.pop()"


def test_star_genexp():
    l = [[SOURCE]]
    g = (*x for x in l)
    SINK(next(g)) # $ MISSING:flow="SOURCE, l:-2 -> next()"


def test_star_dictcomp():
    l = [{"key": SOURCE}]
    merged = {**d for d in l}
    SINK(merged["key"]) # $ MISSING:flow="SOURCE, l:-2 -> merged[..]"
