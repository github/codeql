class Element extends @element {
  string toString() { none() }
}

query predicate new_unspecified_elements(Element e, string property, string error) {
  unspecified_elements(e, property, error)
  or
  error = "Macro declarations removed during database downgrade. Please update your CodeQL code." and
  property = "" and
  macro_decls(e, _)
}
