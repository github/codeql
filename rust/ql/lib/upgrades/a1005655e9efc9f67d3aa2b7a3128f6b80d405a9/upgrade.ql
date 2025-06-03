class Element extends @element {
  string toString() { none() }
}

query predicate new_function_has_implementation(Element e) { function_bodies(e, _) }

query predicate new_const_has_implementation(Element e) { const_bodies(e, _) }
