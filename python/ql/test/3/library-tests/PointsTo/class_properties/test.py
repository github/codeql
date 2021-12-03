from collections import OrderedDict, defaultdict

# Python 3 specific
from collections.abc import Sequence, Mapping

def test(*args):
    pass

class MySequenceABC(Sequence):
    pass

class MyMappingABC(Mapping):
    pass

class MySequenceImpl(object):
    def __getitem__(self, key):
        pass

    def __len__(self):
        pass

class MyDictSubclass(dict):
    pass

test(
    list,
    tuple,
    str,
    unicode,
    bytes,
    MySequenceABC,
    MySequenceImpl,
    set,
    dict,
    OrderedDict,
    defaultdict,
    MyMappingABC,
    MyDictSubclass,
)

for seq_cls in (list, tuple, str, bytes):
    assert issubclass(seq_cls, collections.abc.Sequence)
    assert not issubclass(seq_cls, collections.abc.Mapping)

for map_cls in (dict, OrderedDict, defaultdict):
    assert not issubclass(map_cls, collections.abc.Sequence)
    assert issubclass(map_cls, collections.abc.Mapping)

assert not issubclass(set, collections.abc.Sequence)
assert not issubclass(set, collections.abc.Mapping)
