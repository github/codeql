from collections import OrderedDict, defaultdict
import collections.abc

def test(*args):
    pass

test(
    list,
    tuple,
    str,
    bytes,
    set,
    dict,
    OrderedDict,
    defaultdict,
)

for seq_cls in (list, tuple, str, bytes):
    assert issubclass(seq_cls, collections.abc.Sequence)
    assert not issubclass(seq_cls, collections.abc.Mapping)

for map_cls in (dict, OrderedDict, defaultdict):
    assert not issubclass(map_cls, collections.abc.Sequence)
    assert issubclass(map_cls, collections.abc.Mapping)

assert not issubclass(set, collections.abc.Sequence)
assert not issubclass(set, collections.abc.Mapping)
