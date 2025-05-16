class Element extends @element {
  string toString() { none() }
}

predicate removedClass(Element e, string name, Element child) {
  type_value_exprs(e, child) and
  name = "TypeValueExpr"
  or
  unsafe_cast_exprs(e) and
  name = "UnsafeCastExpr" and
  implicit_conversion_exprs(e, child)
}

predicate removedClass(Element e, string name) {
  integer_types(e, _) and
  name = "IntegerType"
  or
  builtin_fixed_array_types(e) and
  name = "BuiltinFixedArrayType"
  or
  removedClass(e, name, _)
}

query predicate new_unspecified_elements(Element e, string property, string error) {
  unspecified_elements(e, property, error)
  or
  exists(string name |
    removedClass(e, name) and
    property = "" and
    error = name + " nodes removed during database downgrade. Please update your CodeQL code."
  )
}

query predicate new_unspecified_element_children(Element e, int index, Element child) {
  unspecified_element_children(e, index, child)
  or
  removedClass(e, _, child) and index = 0
}

query predicate new_implicit_conversion_exprs(Element e, Element child) {
  implicit_conversion_exprs(e, child) and not removedClass(e, _)
}

query predicate new_expr_types(Element e, Element type) {
  expr_types(e, type) and not removedClass(e, _)
}

query predicate new_types(Element e, string name, Element canonicalType) {
  types(e, name, canonicalType) and not removedClass(e, _)
}
