from collections import defaultdict, namedtuple

# Use to show only interesting results in qltest output
def test(*args):
    pass

def test_construction():
    tainted_string = TAINTED_STRING
    tainted_list = [tainted_string]
    tainted_tuple = (tainted_string,)
    tainted_set = {tainted_string} # TODO: set currently not handled
    tainted_dict = {'key': tainted_string}

    a = list(tainted_list)
    b = list(tainted_tuple)
    c = list(tainted_set) # TODO: set currently not handled
    d = list(tainted_dict.values())
    e = list(tainted_dict.items()) # TODO: dict.items() currently not handled

    f = tuple(tainted_list)
    g = set(tainted_list)
    h = frozenset(tainted_list) # TODO: frozenset constructor currently not handled
    test(a, b, c, d, e, f, g, h)

def test_access():
    tainted_list = TAINTED_LIST
    a = tainted_list[0]
    b = tainted_list[x]
    c = tainted_list[y:z]
    d = tainted_list.copy()
    e, f, g = tainted_list
    test(a, b, c, d, e, f, g)
    for h in tainted_list:
        test(h)
    for i in reversed(tainted_list):
        test(i)

def test_dict_access(x):
    tainted_dict = TAINTED_DICT
    a = tainted_dict["name"]
    b = tainted_dict[x]
    c = tainted_dict.copy()
    test(a, b, c)
    for d in tainted_dict.values():
        test(d)
    for _, e in tainted_dict.items(): # TODO: dict.items() currently not handled
        test(e)

def test_named_tuple(): # TODO: namedtuple currently not handled
    Point = namedtuple('Point', ['x', 'y'])
    point = Point(TAINTED_STRING, 'const')

    a = point[0]
    b = point.x
    c = point[1]
    d = point.y
    e, f = point
    test(a, b, c, d, e, f)

def test_defaultdict(key, x): # TODO: defaultdict currently not handled
    tainted_default_dict = defaultdict(str)
    tainted_default_dict[key] += TAINTED_STRING

    a = tainted_dict["name"]
    b = tainted_dict[x]
    c = tainted_dict.copy()
    test(a, b, c)
    for d in tainted_dict.values():
        test(d)
    for _, e in tainted_dict.items():
        test(e)
