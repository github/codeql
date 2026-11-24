class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

// `CfgPredExpr` and `CfgPredPat` are new node kinds with no representation in the old schema, so we
// scrub their locations and references to them.
private predicate deletedNode(Element id) { cfg_pred_exprs(id) or cfg_pred_pats(id) }

// Comments attached to deleted nodes are also removed, along with their locations.
private predicate deletedElement(Element id) {
  deletedNode(id)
  or
  exists(Element parent | comments(id, parent, _) and deletedNode(parent))
}

query predicate new_locatable_locations(Element id, Location location) {
  locatable_locations(id, location) and not deletedElement(id)
}

query predicate new_macro_call_macro_call_expansions(Element macroCall, Element expansion) {
  macro_call_macro_call_expansions(macroCall, expansion) and not deletedNode(expansion)
}

query predicate new_comments(Element id, Element parent, string text) {
  comments(id, parent, text) and not deletedNode(parent)
}
