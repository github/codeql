class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

// `CfgPredExpr` and `CfgPredPat` are new node kinds with no representation in the old schema, so we
// scrub their locations.
query predicate new_locatable_locations(Element id, Location location) {
  locatable_locations(id, location) and not cfg_pred_exprs(id) and not cfg_pred_pats(id)
}
