# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

from collections import defaultdict, namedtuple

def test_construction():
    tainted_string = TAINTED_STRING
    tainted_list = [tainted_string]
    tainted_tuple = (tainted_string,)
    tainted_set = {tainted_string}
    tainted_dict = {'key': tainted_string}

    ensure_tainted(
        tainted_string, # $ tainted
        tainted_list, # $ tainted
        tainted_tuple, # $ tainted
        tainted_set, # $ tainted
        tainted_dict, # $ tainted
    )

    ensure_tainted(
        list(tainted_list), # $ tainted
        list(tainted_tuple), # $ tainted
        list(tainted_set), # $ tainted
        list(tainted_dict.values()), # $ tainted
        list(tainted_dict.items()), # $ tainted

        tuple(tainted_list), # $ tainted
        set(tainted_list), # $ tainted
        frozenset(tainted_list), # $ tainted
        dict(tainted_dict), # $ tainted
        dict(k = tainted_string)["k"], # $ tainted
        dict(dict(k = tainted_string))["k"], # $ tainted
        dict(["k", tainted_string]), # $ tainted
    )

    ensure_not_tainted(
        dict(k = tainted_string)["k1"]
    )


def test_access(x, y, z):
    tainted_list = TAINTED_LIST

    ensure_tainted(
        tainted_list[0], # $ tainted
        tainted_list[x], # $ tainted
        tainted_list[y:z], # $ tainted

        sorted(tainted_list), # $ tainted
        reversed(tainted_list), # $ tainted
        iter(tainted_list), # $ tainted
        next(iter(tainted_list)), # $ MISSING: tainted
        [i for i in tainted_list], # $ tainted
        [tainted_list for _i in [1,2,3]], # $ tainted
    )

    a, b, c = tainted_list[0:3]
    ensure_tainted(a, b, c) # $ tainted

    for h in tainted_list:
        ensure_tainted(h) # $ tainted
    for i in reversed(tainted_list):
        ensure_tainted(i) # $ tainted

def test_access_explicit(x, y, z):
    tainted_list = [TAINTED_STRING]

    ensure_tainted(
        tainted_list[0], # $ tainted
        tainted_list[x], # $ tainted
        tainted_list[y:z], # $ tainted

        sorted(tainted_list)[0], # $ tainted
        reversed(tainted_list)[0], # $ tainted
        iter(tainted_list), # $ tainted
        next(iter(tainted_list)), # $ tainted
        [i for i in tainted_list], # $ tainted
        [tainted_list for i in [1,2,3]], # $ tainted
        [TAINTED_STRING for i in [1,2,3]], # $ tainted
        [tainted_list], # $ tainted
    )

    a, b, c = tainted_list[0:3]
    ensure_tainted(a, b, c) # $ tainted

    for h in tainted_list:
        ensure_tainted(h) # $ tainted
    for i in reversed(tainted_list):
        ensure_tainted(i) # $ tainted

def test_dict_access(x):
    tainted_dict = TAINTED_DICT

    ensure_tainted(
        tainted_dict["name"], # $ tainted
        tainted_dict.get("name"), # $ tainted
        tainted_dict[x], # $ tainted
        tainted_dict.copy(), # $ tainted
    )

    for v in tainted_dict.values():
        ensure_tainted(v) # $ tainted
    for k, v in tainted_dict.items():
        ensure_tainted(v) # $ tainted


def test_named_tuple(): # TODO: namedtuple currently not handled
    Point = namedtuple('Point', ['x', 'y'])
    point = Point(TAINTED_STRING, 'safe')

    ensure_tainted(
        point[0], # $ MISSING: tainted
        point.x, # $ MISSING: tainted
    )

    ensure_not_tainted(
        point[1],
        point.y,
    )

    a, b = point
    ensure_tainted(a) # $ MISSING: tainted
    ensure_not_tainted(b)


def test_defaultdict(key, x): # TODO: defaultdict currently not handled
    tainted_default_dict = defaultdict(str)
    tainted_default_dict[key] += TAINTED_STRING

    ensure_tainted(
        tainted_default_dict["name"], # $ MISSING: tainted
        tainted_default_dict.get("name"), # $ MISSING: tainted
        tainted_default_dict[x], # $ MISSING: tainted
        tainted_default_dict.copy(), # $ MISSING: tainted
    )
    for v in tainted_default_dict.values():
        ensure_tainted(v) # $ MISSING: tainted
    for k, v in tainted_default_dict.items():
        ensure_tainted(v) # $ MISSING: tainted


def test_copy_1():
    from copy import copy, deepcopy

    ensure_tainted(
        copy(TAINTED_LIST), # $ tainted
        deepcopy(TAINTED_LIST), # $ tainted
    )


def test_copy_2():
    import copy

    ensure_tainted(
        copy.copy(TAINTED_LIST), # $ tainted
        copy.deepcopy(TAINTED_LIST), # $ tainted
    )

def test_replace():
    from copy import replace

    class C:
        def __init__(self, always_tainted, tainted_to_safe, safe_to_tainted, always_safe):
            self.always_tainted = always_tainted
            self.tainted_to_safe = tainted_to_safe
            self.safe_to_tainted = safe_to_tainted
            self.always_safe = always_safe

    c = C(always_tainted=TAINTED_STRING,
          tainted_to_safe=TAINTED_STRING,
          safe_to_tainted=NOT_TAINTED,
          always_safe=NOT_TAINTED)

    d = replace(c, tainted_to_safe=NOT_TAINTED, safe_to_tainted=TAINTED_STRING)

    ensure_tainted(d.always_tainted) # $ tainted
    ensure_tainted(d.safe_to_tainted) # $ tainted
    ensure_not_tainted(d.always_safe)

    # Currently, we have no way of stopping the value in the tainted_to_safe field (which gets
    # overwritten) from flowing through the replace call, which means we get a spurious result.

    ensure_not_tainted(d.tainted_to_safe) # $ SPURIOUS: tainted




def list_index_assign():
    tainted_string = TAINTED_STRING
    my_list = ["safe"]

    ensure_not_tainted(my_list)

    my_list[0] = tainted_string
    ensure_tainted(my_list) # $ MISSING: tainted


def list_index_aug_assign():
    tainted_string = TAINTED_STRING
    my_list = ["safe"]

    ensure_not_tainted(my_list)

    my_list[0] += tainted_string
    ensure_tainted(my_list) # $ MISSING: tainted


def list_append():
    tainted_string = TAINTED_STRING
    my_list = ["safe"]

    ensure_not_tainted(my_list)

    my_list.append(tainted_string)
    ensure_tainted(my_list) # $ tainted


def list_extend():
    my_list = ["safe"]
    tainted_list = [TAINTED_STRING]

    ensure_not_tainted(my_list)

    my_list.extend(tainted_list)
    ensure_tainted(my_list) # $ MISSING: tainted


def dict_update_dict():
    my_dict = {"key1": "safe"}
    tainted_dict = {"key2": TAINTED_STRING}

    ensure_not_tainted(my_dict)

    my_dict.update(tainted_dict)
    ensure_tainted(my_dict) # $ MISSING: tainted


def dict_update_kv_list():
    my_dict = {"key1": "safe"}
    tainted_kv_list = [("key2", TAINTED_STRING)]

    ensure_not_tainted(my_dict)

    my_dict.update(tainted_kv_list)
    ensure_tainted(my_dict) # $ MISSING: tainted


def dict_update_kv_arg():
    my_dict = {"key1": "safe"}

    ensure_not_tainted(my_dict)

    my_dict.update(key2=TAINTED_STRING)
    ensure_tainted(my_dict) # $ MISSING: tainted


def dict_manual_update():
    my_dict = {"key1": "safe"}
    tainted_dict = {"key2": TAINTED_STRING}

    ensure_not_tainted(my_dict)

    for k in tainted_dict:
        my_dict[k] = tainted_dict[k]
    ensure_tainted(my_dict) # $ MISSING: tainted


def dict_merge():
    my_dict = {"key1": "safe"}
    tainted_dict = {"key2": TAINTED_STRING}

    merged = {**my_dict, **tainted_dict}
    ensure_tainted(merged) # $ MISSING: tainted


def set_add():
    tainted_string = TAINTED_STRING
    my_set = {"safe"}

    ensure_not_tainted(my_set)

    my_set.add(tainted_string)
    ensure_tainted(my_set) # $ tainted


# Make tests runable

test_construction()
test_access(0, 0, 2)
test_dict_access("name")
test_named_tuple()
test_defaultdict("key", "key")
test_copy_1()
test_copy_2()
test_replace()

list_index_assign()
list_index_aug_assign()
list_append()
list_extend()

dict_update_dict()
dict_update_kv_list()
dict_update_kv_arg()
dict_manual_update()
dict_merge()

set_add()
