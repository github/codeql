class Element extends @element {
  string toString() { none() }
}

query predicate new_unspecified_elements(Element e, string property, string error) {
  unspecified_elements(e, property, error)
  or
  error = "ThenStmt nodes removed during database downgrade. Please update your CodeQL code." and
  property = "" and
  then_stmts(e, _)
}

query predicate new_unspecified_element_children(Element e, int index, Element child) {
  unspecified_element_children(e, index, child)
  or
  then_stmts(e, child) and index = 0
}
