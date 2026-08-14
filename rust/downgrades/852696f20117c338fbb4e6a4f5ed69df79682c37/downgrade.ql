class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

// Genuinely-new node kinds with no representation in the old schema. Their own child relations are
// dropped via `delete` in upgrade.properties; the references to them from `@ast_node`-typed columns
// (`macro_call_macro_call_expansions`, `comments`) and their `locatable_locations` are scrubbed
// below.
private predicate deletedNode(Element id) {
  deref_pats(id) or
  not_nulls(id) or
  include_bytes_exprs(id) or
  pattern_type_reprs(id) or
  impl_restrictions(id) or
  mut_restrictions(id) or
  visibility_inners(id)
}

// A deleted node, plus any comment attached to one: dropping the comment's `comments` row would
// otherwise leave its `locatable_locations` row dangling.
private predicate deletedElement(Element id) {
  deletedNode(id)
  or
  exists(Element parent | comments(id, parent, _) and deletedNode(parent))
}

// A `@name` used as a format argument's name. The old schema represents these as dedicated text-less
// `@format_args_arg_name` placeholders, so we repurpose these ids into that entity table and drop
// them (and their text) from `names`/`name_texts`.
private predicate formatArgName(Element name) { format_args_arg_names(_, name) }

// The new schema inserts a `VisibilityInner` node between `Visibility` and its path; the old schema
// stores the path directly on the `Visibility`, so we rejoin the two hops.
query predicate new_visibility_paths(Element visibility, Element path) {
  exists(Element inner |
    visibility_visibility_inners(visibility, inner) and
    visibility_inner_paths(inner, path)
  )
}

query predicate new_format_args_arg_names(Element id) { formatArgName(id) }

query predicate new_format_args_arg_arg_names(Element arg, Element name) {
  format_args_arg_names(arg, name)
}

query predicate new_names(Element id) { names(id) and not formatArgName(id) }

query predicate new_name_texts(Element id, string text) {
  name_texts(id, text) and not formatArgName(id)
}

query predicate new_locatable_locations(Element id, Location location) {
  locatable_locations(id, location) and not deletedElement(id)
}

// `macro_call_macro_call_expansions` and `comments` are the only two relations with a generic
// `@ast_node`-typed value column, so a deleted node reachable through a macro expansion or as a
// comment's parent would otherwise dangle here.
query predicate new_macro_call_macro_call_expansions(Element macroCall, Element expansion) {
  macro_call_macro_call_expansions(macroCall, expansion) and not deletedNode(expansion)
}

query predicate new_comments(Element id, Element parent, string text) {
  comments(id, parent, text) and not deletedNode(parent)
}
