class Element extends @element {
  string toString() { none() }
}

query predicate new_item_attribute_macro_expansions(Element id, Element attribute_macro_expansion) {
  expandable_item_attribute_macro_expansions(id, attribute_macro_expansion) and id instanceof @item
}
