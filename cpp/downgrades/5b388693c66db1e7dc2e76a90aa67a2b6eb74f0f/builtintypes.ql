class BuiltinType extends @builtintype {
  string toString() { none() }
}

from BuiltinType type, string name, int kind, int kind_new, int size, int sign, int alignment
where
  builtintypes(type, name, kind, size, sign, alignment) and
  if
    type instanceof @fp16 or
    type instanceof @std_bfloat16 or
    type instanceof @std_float16 or
    type instanceof @complex_std_float32 or
    type instanceof @complex_float32x or
    type instanceof @complex_std_float64 or
    type instanceof @complex_float64x or
    type instanceof @complex_std_float128
  then kind_new = 2
  else kind_new = kind
select type, name, kind_new, size, sign, alignment
