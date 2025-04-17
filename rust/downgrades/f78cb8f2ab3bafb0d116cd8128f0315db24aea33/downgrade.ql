class Element extends @element {
  string toString() { none() }
}

query predicate new_macro_call_expandeds(Element id, Element expanded) {
  item_expandeds(id, expanded) and macro_calls(id)
}
