class BuiltinType extends @builtintype {
  string toString() { none() }
}

predicate isDecimalBuiltinType(BuiltinType type) { builtintypes(type, _, [40, 41, 42], _, _, _) }

from BuiltinType type, string name, int kind, int kind_new, int size, int sign, int alignment
where
  builtintypes(type, name, kind, size, sign, alignment) and
  if isDecimalBuiltinType(type) then kind_new = 1 else kind_new = kind
select type, name, kind_new, size, sign, alignment
