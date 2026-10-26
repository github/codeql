class BuiltinType extends @builtintype {
  string toString() { none() }
}

predicate isFloat128xBuiltinType(BuiltinType type) {
  exists(int kind | builtintypes(type, _, kind, _, _, _) | kind = 50)
}

from BuiltinType type, string name, int kind, int kind_new, int size, int sign, int alignment
where
  builtintypes(type, name, kind, size, sign, alignment) and
  if isFloat128xBuiltinType(type) then kind_new = 1 else kind_new = kind
select type, name, kind_new, size, sign, alignment
