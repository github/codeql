class NoBase: pass

class EmptyBase(): pass

class PrimitiveBase(int): pass

class ManyBases(list, object): pass

class SubscriptBase(list[int]): pass

class WalrusBase(foo:=object): pass

class AttrBase(typing.List): pass

class TypedBase[K, V](dict[K, V]): pass

class EllipsisBase(tuple[int, ...]): pass

class NestedBase[K, V](dict[tuple[K, ...], list[V]]): pass
