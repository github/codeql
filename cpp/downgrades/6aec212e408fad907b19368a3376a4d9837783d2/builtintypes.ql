class BuiltInType extends @builtintype {
  string toString() { none() }
}

from BuiltInType type, string name, int kind, int kind_new, int size, int sign, int alignment
where
  builtintypes(type, name, kind, size, sign, alignment) and
  if kind in [67, 68, 69] then kind_new = 1 else kind_new = kind
select type, name, kind_new, size, sign, alignment
