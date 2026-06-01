class BuiltinFixedArrayType extends @builtin_fixed_array_type {
  string toString() { none() }
}

from BuiltinFixedArrayType builtinFixedArrayType
where builtin_fixed_array_types(builtinFixedArrayType, _, _)
select builtinFixedArrayType
