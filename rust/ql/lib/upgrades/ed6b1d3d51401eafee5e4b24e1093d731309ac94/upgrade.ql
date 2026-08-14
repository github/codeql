class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

// The old schema stored a visibility's path directly on the `Visibility`. The new schema inserts a
// genuinely-new `VisibilityInner` node between `Visibility` and its path, so we synthesise one per
// visibility that has a path, reusing the visibility's location.
newtype TSynth = TVisibilityInner(Element visibility) { visibility_paths(visibility, _) }

module Fresh = QlBuiltins::NewEntity<TSynth>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

query predicate new_visibility_inners(Fresh::EntityId id) { id = Fresh::map(TVisibilityInner(_)) }

query predicate new_visibility_visibility_inners(Element visibility, Fresh::EntityId inner) {
  inner = Fresh::map(TVisibilityInner(visibility))
}

query predicate new_visibility_inner_paths(Fresh::EntityId inner, Element path) {
  exists(Element visibility |
    inner = Fresh::map(TVisibilityInner(visibility)) and
    visibility_paths(visibility, path)
  )
}

// The old schema represented a format argument's name as a dedicated text-less
// `@format_args_arg_name` placeholder (entity table `format_args_arg_names`, linked to the arg via
// `format_args_arg_arg_names`). The new schema uses a regular `@name` node instead, so we repurpose
// the placeholder ids as `@name`s by adding them to `names`. They carry no text; re-extraction
// recovers it.
query predicate new_names(Element id) { names(id) or format_args_arg_names(id) }

query predicate new_format_args_arg_names(Element arg, Element name) {
  format_args_arg_arg_names(arg, name)
}

query predicate new_locatable_locations(NewElement id, Location location) {
  locatable_locations(id, location)
  or
  exists(Element visibility |
    id = Fresh::map(TVisibilityInner(visibility)) and
    locatable_locations(visibility, location)
  )
}
