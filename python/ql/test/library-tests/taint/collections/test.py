from collections import defaultdict, namedtuple

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

def test_access():
    tainted_list = TAINTED_LIST
    a = tainted_list[0]
    b = tainted_list[x]
    c = tainted_list[y:z]
    d = tainted_list.copy()
    e, f, g = tainted_list # TODO: currently not handled
    for h in tainted_list:
        h
    for i in reversed(tainted_list):
        i

def test_dict_access(x):
    tainted_dict = TAINTED_DICT
    a = tainted_dict["name"]
    b = tainted_dict[x]
    c = tainted_dict.copy()
    for d in tainted_dict.values():
        d
    for _, e in tainted_dict.items(): # TODO: dict.items() currently not handled
        e

def test_named_tuple(): # TODO: namedtuple currently not handled
    Point = namedtuple('Point', ['x', 'y'])
    point = Point(TAINTED_STRING, 'const')

    a = point[0]
    b = point.x
    c = point[1]
    d = point.y
    e, f = point

def test_defaultdict(key, x): # TODO: defaultdict currently not handled
    tainted_default_dict = defaultdict(str)
    tainted_default_dict[key] += TAINTED_STRING

    a = tainted_dict["name"]
    b = tainted_dict[x]
    c = tainted_dict.copy()
    for d in tainted_dict.values():
        d
    for _, e in tainted_dict.items():
        e
