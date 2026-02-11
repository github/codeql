class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

query predicate new_closure_binders(Element id) {
  for_binders(id) and closure_expr_for_binders(_, id)
}

query predicate new_closure_binder_generic_param_lists(Element id, Element list) {
  for_binder_generic_param_lists(id, list) and closure_expr_for_binders(_, id)
}

query predicate new_where_pred_generic_param_lists(Element id, Element list) {
  exists(Element forBinder |
    where_pred_for_binders(id, forBinder) and
    for_binder_generic_param_lists(forBinder, list)
  )
}

// We need to transform `TypeBound(for_binder=ForBinder(generic_param_list=X), type_repr=Y)`
// into `TypeBound(type_repr=ForTypeRepr(generic_param_list=X, type_repr=Y))`
// we repurpose the `@for_binder` id into a `@for_type_repr` one
query predicate new_for_type_reprs(Element id) {
  for_type_reprs(id) or
  exists(Element typeBound | type_bound_for_binders(typeBound, id))
}

query predicate new_for_type_repr_generic_param_lists(Element id, Element list) {
  exists(Element forBinder |
    for_type_repr_for_binders(id, forBinder) and for_binder_generic_param_lists(forBinder, list)
  )
  or
  exists(Element typeBound |
    type_bound_for_binders(typeBound, id) and for_binder_generic_param_lists(id, list)
  )
}

query predicate new_for_type_repr_type_reprs(Element id, Element type) {
  for_type_repr_type_reprs(id, type)
  or
  exists(Element typeBound |
    type_bound_for_binders(typeBound, id) and type_bound_type_reprs(typeBound, type)
  )
}

query predicate new_type_bound_type_reprs(Element bound, Element type) {
  type_bound_type_reprs(bound, type) and not type_bound_for_binders(bound, _)
  or
  type_bound_for_binders(bound, type)
}

// remove locations of removed @for_binder elements
query predicate new_locatable_locations(Element id, Location loc) {
  locatable_locations(id, loc) and not where_pred_for_binders(_, id)
}

// remove @asm_expr from the subtypes of @item (and therefore @addressable and @stmt)
// this means removing any @asm_expr ids from tables that accept @item, @stmt or @addressable
query predicate new_item_attribute_macro_expansions(Element id, Element items) {
  item_attribute_macro_expansions(id, items) and not asm_exprs(id)
}

query predicate new_item_list_items(Element id, int index, Element item) {
  item_list_items(id, index, item) and not asm_exprs(item)
}

query predicate new_macro_items_items(Element id, int index, Element item) {
  macro_items_items(id, index, item) and not asm_exprs(item)
}

query predicate new_source_file_items(Element id, int index, Element item) {
  source_file_items(id, index, item) and not asm_exprs(item)
}

query predicate new_stmt_list_statements(Element id, int index, Element stmt) {
  stmt_list_statements(id, index, stmt) and not asm_exprs(stmt)
}

query predicate new_macro_block_expr_statements(Element id, int index, Element stmt) {
  macro_block_expr_statements(id, index, stmt) and not asm_exprs(stmt)
}

query predicate new_addressable_extended_canonical_paths(Element id, string path) {
  addressable_extended_canonical_paths(id, path) and not asm_exprs(id)
}

query predicate new_addressable_crate_origins(Element id, string crate) {
  addressable_crate_origins(id, crate) and not asm_exprs(id)
}
