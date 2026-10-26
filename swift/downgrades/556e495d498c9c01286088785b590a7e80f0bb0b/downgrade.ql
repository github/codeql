class Element extends @element {
  string toString() { none() }
}

query predicate new_unspecified_elements(Element e, string property, string error) {
  unspecified_elements(e, property, error)
  or
  error =
    "Move semantics support removed during database downgrade. Please update your CodeQL code." and
  property = "" and
  (
    copy_exprs(e, _) or
    consume_exprs(e, _) or
    borrow_exprs(e)
  )
}

query predicate new_unspecified_element_children(Element e, int index, Element child) {
  unspecified_element_children(e, index, child)
  or
  copy_exprs(e, child) and index = 0
  or
  consume_exprs(e, child) and index = 0
  or
  borrow_exprs(e) and identity_exprs(e, child) and index = 0
}

query predicate new_identity_exprs(Element e, Element child) {
  identity_exprs(e, child) and not borrow_exprs(e)
}
