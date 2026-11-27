# Classes without __eq__ are hashable (inherit __hash__ from object)
class NoEqClass:
    def __init__(self, x):
        self.x = x

def hash_no_eq():
    obj = NoEqClass(1)
    return hash(obj)  # OK: no __eq__, so __hash__ is inherited from object

# Classes with __eq__ but no __hash__ are unhashable
class HasEqNoHash:
    def __eq__(self, other):
        return self.x == other.x

def hash_eq_no_hash():
    obj = HasEqNoHash()
    return hash(obj)  # should be flagged

# @dataclass(frozen=True) generates __hash__, so instances are hashable
from dataclasses import dataclass

@dataclass(frozen=True)
class FrozenPoint:
    x: int
    y: int

def hash_frozen_dataclass():
    p = FrozenPoint(1, 2)
    return hash(p)  # OK: frozen dataclass has __hash__

# @dataclass(unsafe_hash=True) also generates __hash__
@dataclass(unsafe_hash=True)
class UnsafeHashPoint:
    x: int
    y: int

def hash_unsafe_hash_dataclass():
    p = UnsafeHashPoint(1, 2)
    return hash(p)  # OK: unsafe_hash=True generates __hash__

# Plain @dataclass without frozen/unsafe_hash and with __eq__ is unhashable
@dataclass
class MutableDataclass:
    x: int

def hash_mutable_dataclass():
    p = MutableDataclass(1)
    return hash(p)  # should be flagged: @dataclass generates __eq__ but not __hash__
