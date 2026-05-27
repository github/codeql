class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

private predicate wrapperConstArg(Element id) {
  struct_field_default_vals(_, id) or variant_const_args(_, id)
}

private predicate traitIsAlias(Element id) {
  traits(id) and trait_type_bound_lists(id, _) and not trait_assoc_item_lists(id, _)
}

private predicate sourceMeta(Element id) {
  path_meta(id) or
  key_value_meta(id) or
  token_tree_meta(id) or
  unsafe_meta(id) or
  cfg_meta(id) or
  cfg_attr_meta(id)
}

private predicate unsafeInnerMeta(Element id) {
  unsafe_meta_meta(_, id)
}

private predicate metaPath(Element id, Element path) {
  path_meta_paths(id, path) or key_value_meta_paths(id, path) or token_tree_meta_paths(id, path)
}

private predicate metaExpr(Element id, Element expr) {
  key_value_meta_exprs(id, expr)
}

private predicate metaTokenTree(Element id, Element tokenTree) {
  token_tree_meta_token_trees(id, tokenTree)
}

private predicate deletedElement(Element id) {
  wrapperConstArg(id) or
  unsafeInnerMeta(id) or
  cfg_atoms(id) or
  cfg_composites(id) or
  format_args_arg_names(id) or
  try_block_modifiers(id)
}

query predicate new_block_expr_is_try(Element id) {
  exists(Element modifier | block_expr_try_block_modifiers(id, modifier) and try_block_modifier_is_try(modifier))
}

query predicate new_names(Element id) {
  names(id) or format_args_arg_names(id)
}

query predicate new_format_args_arg_names(Element id, Element name) {
  format_args_arg_arg_names(id, name)
}

query predicate new_const_args(Element id) {
  const_args(id) and not wrapperConstArg(id)
}

query predicate new_const_arg_exprs(Element id, Element expr) {
  const_arg_exprs(id, expr) and not wrapperConstArg(id)
}

query predicate new_comments(Element id, Element parent, string text) {
  comments(id, parent, text) and not deletedElement(parent)
}

query predicate new_struct_field_defaults(Element id, Element expr) {
  exists(Element constArg | struct_field_default_vals(id, constArg) and const_arg_exprs(constArg, expr))
}

query predicate new_variant_discriminants(Element id, Element expr) {
  exists(Element constArg | variant_const_args(id, constArg) and const_arg_exprs(constArg, expr))
}

query predicate new_meta(Element id) {
  sourceMeta(id) and not unsafeInnerMeta(id)
}

query predicate new_meta_paths(Element id, Element path) {
  metaPath(id, path) and not unsafeInnerMeta(id)
  or
  exists(Element inner | unsafe_meta_meta(id, inner) and metaPath(inner, path))
}

query predicate new_meta_exprs(Element id, Element expr) {
  metaExpr(id, expr) and not unsafeInnerMeta(id)
  or
  exists(Element inner | unsafe_meta_meta(id, inner) and metaExpr(inner, expr))
}

query predicate new_meta_token_trees(Element id, Element tokenTree) {
  metaTokenTree(id, tokenTree) and not unsafeInnerMeta(id)
  or
  exists(Element inner | unsafe_meta_meta(id, inner) and metaTokenTree(inner, tokenTree))
}

query predicate new_meta_is_unsafe(Element id) {
  unsafe_meta_is_unsafe(id)
}

query predicate new_traits(Element id) {
  traits(id) and not traitIsAlias(id)
}

query predicate new_trait_assoc_item_lists(Element id, Element assocItemList) {
  trait_assoc_item_lists(id, assocItemList) and not traitIsAlias(id)
}

query predicate new_trait_attrs(Element id, int index, Element attr) {
  trait_attrs(id, index, attr) and not traitIsAlias(id)
}

query predicate new_trait_generic_param_lists(Element id, Element genericParamList) {
  trait_generic_param_lists(id, genericParamList) and not traitIsAlias(id)
}

query predicate new_trait_is_auto(Element id) {
  trait_is_auto(id) and not traitIsAlias(id)
}

query predicate new_trait_is_unsafe(Element id) {
  trait_is_unsafe(id) and not traitIsAlias(id)
}

query predicate new_trait_names(Element id, Element name) {
  trait_names(id, name) and not traitIsAlias(id)
}

query predicate new_trait_type_bound_lists(Element id, Element typeBoundList) {
  trait_type_bound_lists(id, typeBoundList) and not traitIsAlias(id)
}

query predicate new_trait_visibilities(Element id, Element visibility) {
  trait_visibilities(id, visibility) and not traitIsAlias(id)
}

query predicate new_trait_where_clauses(Element id, Element whereClause) {
  trait_where_clauses(id, whereClause) and not traitIsAlias(id)
}

query predicate new_trait_aliases(Element id) {
  traitIsAlias(id)
}

query predicate new_trait_alias_attrs(Element id, int index, Element attr) {
  trait_attrs(id, index, attr) and traitIsAlias(id)
}

query predicate new_trait_alias_generic_param_lists(Element id, Element genericParamList) {
  trait_generic_param_lists(id, genericParamList) and traitIsAlias(id)
}

query predicate new_trait_alias_names(Element id, Element name) {
  trait_names(id, name) and traitIsAlias(id)
}

query predicate new_trait_alias_type_bound_lists(Element id, Element typeBoundList) {
  trait_type_bound_lists(id, typeBoundList) and traitIsAlias(id)
}

query predicate new_trait_alias_visibilities(Element id, Element visibility) {
  trait_visibilities(id, visibility) and traitIsAlias(id)
}

query predicate new_trait_alias_where_clauses(Element id, Element whereClause) {
  trait_where_clauses(id, whereClause) and traitIsAlias(id)
}

query predicate new_locatable_locations(Element id, Location location) {
  locatable_locations(id, location) and not deletedElement(id)
}
