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
        tainted_string,
        tainted_list,
        tainted_tuple,
        tainted_set,
        tainted_dict,
    )

    ensure_tainted(
        list(tainted_list),
        list(tainted_tuple),
        list(tainted_set),
        list(tainted_dict.values()),
        list(tainted_dict.items()),

        tuple(tainted_list),
        set(tainted_list),
        frozenset(tainted_list),
    )


def test_access(x, y, z):
    tainted_list = TAINTED_LIST

    ensure_tainted(
        tainted_list[0],
        tainted_list[x],
        tainted_list[y:z],

        sorted(tainted_list),
        reversed(tainted_list),
        iter(tainted_list),
        next(iter(tainted_list)),
    )

    a, b, c = tainted_list[0:3]
    ensure_tainted(a, b, c)

    for h in tainted_list:
        ensure_tainted(h)
    for i in reversed(tainted_list):
        ensure_tainted(i)


def test_dict_access(x):
    tainted_dict = TAINTED_DICT

    ensure_tainted(
        tainted_dict["name"],
        tainted_dict.get("name"),
        tainted_dict[x],
        tainted_dict.copy(),
    )

    for v in tainted_dict.values():
        ensure_tainted(v)
    for k, v in tainted_dict.items():
        ensure_tainted(v)


def test_named_tuple(): # TODO: namedtuple currently not handled
    Point = namedtuple('Point', ['x', 'y'])
    point = Point(TAINTED_STRING, 'safe')

    ensure_tainted(
        point[0],
        point.x,
    )

    ensure_not_tainted(
        point[1],
        point.y,
    )

    a, b = point
    ensure_tainted(a)
    ensure_not_tainted(b)


def test_defaultdict(key, x): # TODO: defaultdict currently not handled
    tainted_default_dict = defaultdict(str)
    tainted_default_dict[key] += TAINTED_STRING

    ensure_tainted(
        tainted_default_dict["name"],
        tainted_default_dict.get("name"),
        tainted_default_dict[x],
        tainted_default_dict.copy(),
    )
    for v in tainted_default_dict.values():
        ensure_tainted(v)
    for k, v in tainted_default_dict.items():
        ensure_tainted(v)


def test_copy_1():
    from copy import copy, deepcopy

    ensure_tainted(
        copy(TAINTED_LIST),
        deepcopy(TAINTED_LIST),
    )


def test_copy_2():
    import copy

    ensure_tainted(
        copy.copy(TAINTED_LIST),
        copy.deepcopy(TAINTED_LIST),
    )


def list_index_assign():
    tainted_string = TAINTED_STRING
    my_list = ["safe"]

    ensure_not_tainted(my_list)

    my_list[0] = tainted_string
    ensure_tainted(my_list)


def list_index_aug_assign():
    tainted_string = TAINTED_STRING
    my_list = ["safe"]

    ensure_not_tainted(my_list)

    my_list[0] += tainted_string
    ensure_tainted(my_list)


def list_append():
    tainted_string = TAINTED_STRING
    my_list = ["safe"]

    ensure_not_tainted(my_list)

    my_list.append(tainted_string)
    ensure_tainted(my_list)


def list_extend():
    my_list = ["safe"]
    tainted_list = [TAINTED_STRING]

    ensure_not_tainted(my_list)

    my_list.extend(tainted_list)
    ensure_tainted(my_list)


def dict_update_dict():
    my_dict = {"key1": "safe"}
    tainted_dict = {"key2": TAINTED_STRING}

    ensure_not_tainted(my_dict)

    my_dict.update(tainted_dict)
    ensure_tainted(my_dict)


def dict_update_kv_list():
    my_dict = {"key1": "safe"}
    tainted_kv_list = [("key2", TAINTED_STRING)]

    ensure_not_tainted(my_dict)

    my_dict.update(tainted_kv_list)
    ensure_tainted(my_dict)


def dict_update_kv_arg():
    my_dict = {"key1": "safe"}

    ensure_not_tainted(my_dict)

    my_dict.update(key2=TAINTED_STRING)
    ensure_tainted(my_dict)


def dict_manual_update():
    my_dict = {"key1": "safe"}
    tainted_dict = {"key2": TAINTED_STRING}

    ensure_not_tainted(my_dict)

    for k in tainted_dict:
        my_dict[k] = tainted_dict[k]
    ensure_tainted(my_dict)


def dict_merge():
    my_dict = {"key1": "safe"}
    tainted_dict = {"key2": TAINTED_STRING}

    merged = {**my_dict, **tainted_dict}
    ensure_tainted(merged)


def set_add():
    tainted_string = TAINTED_STRING
    my_set = {"safe"}

    ensure_not_tainted(my_set)

    my_set.add(tainted_string)
    ensure_tainted(my_set)


# Make tests runable

test_construction()
test_access(0, 0, 2)
test_dict_access("name")
test_named_tuple()
test_defaultdict("key", "key")
test_copy_1()
test_copy_2()

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
