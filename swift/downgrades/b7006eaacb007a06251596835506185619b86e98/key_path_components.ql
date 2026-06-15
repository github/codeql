class KeyPathComponent extends @key_path_component {
  string toString() { none() }
}

class Element extends @element {
  string toString() { none() }
}

class ArgumentOrNone extends @argument_or_none {
  string toString() { none() }
}

class TypeOrNone extends @type_or_none {
  string toString() { none() }
}

class ValueDeclOrNone extends @value_decl_or_none {
  string toString() { none() }
}

predicate isKeyPathComponentWithNewKind(KeyPathComponent id) {
  key_path_components(id, 1, _) or key_path_components(id, 4, _)
}

query predicate new_key_path_components(KeyPathComponent id, int kind, TypeOrNone component_type) {
  exists(int old_kind |
    key_path_components(id, old_kind, component_type) and
    not isKeyPathComponentWithNewKind(id) and
    if old_kind = 0
    then kind = old_kind
    else
      if old_kind = 2 or old_kind = 3
      then kind = old_kind - 1
      else kind = old_kind - 2
  )
}

query predicate new_key_path_component_subscript_arguments(
  KeyPathComponent id, int index, ArgumentOrNone subscript_argument
) {
  key_path_component_subscript_arguments(id, index, subscript_argument) and
  not isKeyPathComponentWithNewKind(id)
}

query predicate new_key_path_component_tuple_indices(KeyPathComponent id, int tuple_index) {
  key_path_component_tuple_indices(id, tuple_index) and
  not isKeyPathComponentWithNewKind(id)
}

query predicate new_key_path_component_decl_refs(KeyPathComponent id, ValueDeclOrNone decl_ref) {
  key_path_component_decl_refs(id, decl_ref) and
  not isKeyPathComponentWithNewKind(id)
}

query predicate new_unspecified_elements(Element id, string property, string error) {
  unspecified_elements(id, property, error)
  or
  isKeyPathComponentWithNewKind(id) and
  property = "" and
  error =
    "UnresolvedApply and Apply KeyPathComponents removed during database downgrade. Please update your CodeQL."
}
