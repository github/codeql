class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

private predicate oldMetaHasExpr(Element meta) { meta_exprs(meta, _) }

private predicate oldMetaHasPath(Element meta) { meta_paths(meta, _) }

private predicate oldMetaHasTokenTree(Element meta) { meta_token_trees(meta, _) }

private predicate oldMetaIsPath(Element meta) {
  oldMetaHasPath(meta) and not oldMetaHasExpr(meta) and not oldMetaHasTokenTree(meta)
}

private predicate oldMetaIsKeyValue(Element meta) { oldMetaHasPath(meta) and oldMetaHasExpr(meta) }

private predicate oldMetaIsTokenTree(Element meta) {
  oldMetaHasPath(meta) and oldMetaHasTokenTree(meta) and not oldMetaHasExpr(meta)
}

private predicate oldMetaHasInnerShape(Element meta) {
  oldMetaIsPath(meta) or oldMetaIsKeyValue(meta) or oldMetaIsTokenTree(meta)
}

newtype TAddedElement =
  TFormatArgsArgName(Element arg, Element name) { format_args_arg_names(arg, name) } or
  TTryBlockModifier(Element block) { block_expr_is_try(block) } or
  TStructFieldDefaultConstArg(Element field, Element expr) { struct_field_defaults(field, expr) } or
  TVariantDiscriminantConstArg(Element variant, Element expr) {
    variant_discriminants(variant, expr)
  } or
  TUnsafePathMeta(Element meta) { meta_is_unsafe(meta) and oldMetaIsPath(meta) } or
  TUnsafeKeyValueMeta(Element meta) { meta_is_unsafe(meta) and oldMetaIsKeyValue(meta) } or
  TUnsafeTokenTreeMeta(Element meta) { meta_is_unsafe(meta) and oldMetaIsTokenTree(meta) }

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

private predicate isFreshInnerMeta(NewElement id, Element oldMeta) {
  id = Fresh::map(TUnsafePathMeta(oldMeta)) or
  id = Fresh::map(TUnsafeKeyValueMeta(oldMeta)) or
  id = Fresh::map(TUnsafeTokenTreeMeta(oldMeta))
}

query predicate new_format_args_arg_names(NewElement id) {
  id = Fresh::map(TFormatArgsArgName(_, _))
}

query predicate new_format_args_arg_arg_names(Element id, NewElement arg_name) {
  arg_name = Fresh::map(TFormatArgsArgName(id, _))
}

query predicate new_try_block_modifiers(NewElement id) { id = Fresh::map(TTryBlockModifier(_)) }

query predicate new_try_block_modifier_is_try(NewElement id) {
  id = Fresh::map(TTryBlockModifier(_))
}

query predicate new_block_expr_try_block_modifiers(Element id, NewElement try_block_modifier) {
  try_block_modifier = Fresh::map(TTryBlockModifier(id))
}

query predicate new_const_args(NewElement id) {
  const_args(id) or
  id = Fresh::map(TStructFieldDefaultConstArg(_, _)) or
  id = Fresh::map(TVariantDiscriminantConstArg(_, _))
}

query predicate new_const_arg_exprs(NewElement id, Element expr) {
  const_arg_exprs(id, expr) or
  id = Fresh::map(TStructFieldDefaultConstArg(_, expr)) or
  id = Fresh::map(TVariantDiscriminantConstArg(_, expr))
}

query predicate new_struct_field_default_vals(Element id, NewElement default_val) {
  default_val = Fresh::map(TStructFieldDefaultConstArg(id, _))
}

query predicate new_variant_const_args(Element id, NewElement const_arg) {
  const_arg = Fresh::map(TVariantDiscriminantConstArg(id, _))
}

query predicate new_traits(Element id) { traits(id) or trait_aliases(id) }

query predicate new_trait_attrs(Element id, int index, Element attr) {
  trait_attrs(id, index, attr) or trait_alias_attrs(id, index, attr)
}

query predicate new_trait_generic_param_lists(Element id, Element generic_param_list) {
  trait_generic_param_lists(id, generic_param_list) or
  trait_alias_generic_param_lists(id, generic_param_list)
}

query predicate new_trait_names(Element id, Element name) {
  trait_names(id, name) or trait_alias_names(id, name)
}

query predicate new_trait_type_bound_lists(Element id, Element type_bound_list) {
  trait_type_bound_lists(id, type_bound_list) or trait_alias_type_bound_lists(id, type_bound_list)
}

query predicate new_trait_visibilities(Element id, Element visibility) {
  trait_visibilities(id, visibility) or trait_alias_visibilities(id, visibility)
}

query predicate new_trait_where_clauses(Element id, Element where_clause) {
  trait_where_clauses(id, where_clause) or trait_alias_where_clauses(id, where_clause)
}

query predicate new_path_meta(NewElement id) {
  meta(id) and not meta_is_unsafe(id) and oldMetaIsPath(id)
  or
  id = Fresh::map(TUnsafePathMeta(_))
}

query predicate new_path_meta_paths(NewElement id, Element path) {
  meta_paths(id, path) and not meta_is_unsafe(id) and oldMetaIsPath(id)
  or
  exists(Element oldMeta | id = Fresh::map(TUnsafePathMeta(oldMeta)) and meta_paths(oldMeta, path))
}

query predicate new_key_value_meta(NewElement id) {
  meta(id) and not meta_is_unsafe(id) and oldMetaIsKeyValue(id)
  or
  id = Fresh::map(TUnsafeKeyValueMeta(_))
}

query predicate new_key_value_meta_exprs(NewElement id, Element expr) {
  meta_exprs(id, expr) and not meta_is_unsafe(id) and oldMetaIsKeyValue(id)
  or
  exists(Element oldMeta |
    id = Fresh::map(TUnsafeKeyValueMeta(oldMeta)) and meta_exprs(oldMeta, expr)
  )
}

query predicate new_key_value_meta_paths(NewElement id, Element path) {
  meta_paths(id, path) and not meta_is_unsafe(id) and oldMetaIsKeyValue(id)
  or
  exists(Element oldMeta |
    id = Fresh::map(TUnsafeKeyValueMeta(oldMeta)) and meta_paths(oldMeta, path)
  )
}

query predicate new_token_tree_meta(NewElement id) {
  meta(id) and not meta_is_unsafe(id) and oldMetaIsTokenTree(id)
  or
  id = Fresh::map(TUnsafeTokenTreeMeta(_))
}

query predicate new_token_tree_meta_paths(NewElement id, Element path) {
  meta_paths(id, path) and not meta_is_unsafe(id) and oldMetaIsTokenTree(id)
  or
  exists(Element oldMeta |
    id = Fresh::map(TUnsafeTokenTreeMeta(oldMeta)) and meta_paths(oldMeta, path)
  )
}

query predicate new_token_tree_meta_token_trees(NewElement id, Element token_tree) {
  meta_token_trees(id, token_tree) and not meta_is_unsafe(id) and oldMetaIsTokenTree(id)
  or
  exists(Element oldMeta |
    id = Fresh::map(TUnsafeTokenTreeMeta(oldMeta)) and meta_token_trees(oldMeta, token_tree)
  )
}

query predicate new_unsafe_meta(Element id) { meta_is_unsafe(id) }

query predicate new_unsafe_meta_is_unsafe(Element id) { meta_is_unsafe(id) }

query predicate new_unsafe_meta_meta(Element id, NewElement inner) {
  meta_is_unsafe(id) and oldMetaHasInnerShape(id) and isFreshInnerMeta(inner, id)
}

query predicate new_locatable_locations(NewElement id, Location location) {
  locatable_locations(id, location)
  or
  exists(Element arg, Element name |
    id = Fresh::map(TFormatArgsArgName(arg, name)) and locatable_locations(name, location)
  )
  or
  exists(Element block |
    id = Fresh::map(TTryBlockModifier(block)) and locatable_locations(block, location)
  )
  or
  exists(Element field, Element expr |
    id = Fresh::map(TStructFieldDefaultConstArg(field, expr)) and
    locatable_locations(expr, location)
  )
  or
  exists(Element variant, Element expr |
    id = Fresh::map(TVariantDiscriminantConstArg(variant, expr)) and
    locatable_locations(expr, location)
  )
  or
  exists(Element oldMeta | isFreshInnerMeta(id, oldMeta) and locatable_locations(oldMeta, location))
}
