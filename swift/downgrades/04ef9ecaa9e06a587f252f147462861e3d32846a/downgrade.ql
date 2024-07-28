class Element extends @element {
  string toString() { none() }
}

query predicate new_unspecified_elements(Element e, string property, string error) {
  unspecified_elements(e, property, error)
  or
  error = "Parameter packs removed during database downgrade. Please update your CodeQL code." and
  property = "" and
  (
    pack_element_exprs(e, _) or
    pack_expansion_exprs(e, _) or
    pack_element_types(e, _) or
    pack_expansion_types(e, _, _) or
    pack_types(e) or
    element_archetype_types(e)
  )
}

query predicate new_unspecified_element_children(Element e, int index, Element child) {
  unspecified_element_children(e, index, child)
  or
  pack_element_exprs(e, child) and index = 0
  or
  pack_expansion_exprs(e, child) and index = 0
}
