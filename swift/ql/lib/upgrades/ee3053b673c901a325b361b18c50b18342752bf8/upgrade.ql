class BuiltinFixedArrayType extends @builtin_fixed_array_type {
  string toString() { none() }
}

newtype TAddedElement =
  TSize(BuiltinFixedArrayType a) or
  TElementType(BuiltinFixedArrayType a)

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

class TypeOrNone extends @type_or_none {
  string toString() { none() }
}

query predicate new_builtin_fixed_array_types(
  BuiltinFixedArrayType builtinFixedArrayType, NewElement size, NewElement elementType
) {
  builtin_fixed_array_types(builtinFixedArrayType) and
  Fresh::map(TSize(builtinFixedArrayType)) = size and
  Fresh::map(TElementType(builtinFixedArrayType)) = elementType
}

query predicate new_unspecified_elements(NewElement id, string property, string error) {
  unspecified_elements(id, property, error)
  or
  exists(BuiltinFixedArrayType builtinFixedArrayType |
    builtin_fixed_array_types(builtinFixedArrayType)
  |
    id = Fresh::map(TSize(builtinFixedArrayType)) and
    error = "BuiltinFixedArrayType size missing after upgrade. Please update your CodeQL code." and
    property = ""
    or
    id = Fresh::map(TElementType(builtinFixedArrayType)) and
    error =
      "BuiltinFixedArrayType element type missing after upgrade. Please update your CodeQL code." and
    property = ""
  )
}
