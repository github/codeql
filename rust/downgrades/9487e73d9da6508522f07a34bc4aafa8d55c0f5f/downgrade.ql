class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

// The new node kinds have no representation in the old schema. Their own relations are dropped via
// `delete` in upgrade.properties; their `locatable_locations` rows are scrubbed below.
private predicate deletedNode(Element id) { cfg_pred_exprs(id) or cfg_pred_pats(id) }

// A deleted node, plus any comment attached to one: dropping the comment's `comments` row would
// otherwise leave its `locatable_locations` row dangling.
private predicate deletedElement(Element id) {
  deletedNode(id)
  or
  exists(Element parent | comments(id, parent, _) and deletedNode(parent))
}

query predicate new_locatable_locations(Element id, Location location) {
  locatable_locations(id, location) and not deletedElement(id)
}
