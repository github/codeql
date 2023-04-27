class BuiltinType extends @builtintype {
  string toString() { none() }
}

from BuiltinType type, string name, int kind, int kind_new, int size, int sign, int alignment
where
  builtintypes(type, name, kind, size, sign, alignment) and
  if type instanceof @float16 or type instanceof @complex_float16
  then kind_new = 2
  else kind_new = kind
select type, name, kind_new, size, sign, alignment
