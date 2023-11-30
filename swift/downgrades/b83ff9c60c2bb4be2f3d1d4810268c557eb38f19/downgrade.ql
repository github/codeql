class Element extends @element {
  string toString() { none() }
}

query predicate new_unspecified_elements(Element e, string property, string error) {
  unspecified_elements(e, property, error)
  or
  error =
    "DiscardStmt and MaterializePackExpr removed during database downgrade. Please update your CodeQL code." and
  property = "" and
  (
    materialize_pack_exprs(e, _) or
    discard_stmts(e, _)
  )
}

query predicate new_unspecified_element_children(Element e, int index, Element child) {
  unspecified_element_children(e, index, child)
  or
  materialize_pack_exprs(e, child) and index = 0
  or
  discard_stmts(e, child) and index = 0
}
