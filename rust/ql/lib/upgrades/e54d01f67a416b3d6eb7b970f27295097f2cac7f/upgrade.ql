class Element extends @element {
  string toString() { none() }
}

class Adt extends Element, @adt { }

class Attr extends Element, @attr { }

class GenericParamList extends Element, @generic_param_list { }

class Name extends Element, @name { }

class Visibility extends Element, @visibility { }

class WhereClause extends Element, @where_clause { }

query predicate new_type_item_attrs(Adt adt, int index, Attr attr) {
  enum_attrs(adt, index, attr) or
  struct_attrs(adt, index, attr) or
  union_attrs(adt, index, attr)
}

query predicate new_type_item_generic_param_lists(Adt adt, GenericParamList g) {
  enum_generic_param_lists(adt, g) or
  struct_generic_param_lists(adt, g) or
  union_generic_param_lists(adt, g)
}

query predicate new_type_item_names(Adt adt, Name name) {
  enum_names(adt, name) or
  struct_names(adt, name) or
  union_names(adt, name)
}

query predicate new_type_item_visibilities(Adt adt, Visibility visibility) {
  enum_visibilities(adt, visibility) or
  struct_visibilities(adt, visibility) or
  union_visibilities(adt, visibility)
}

query predicate new_type_item_where_clauses(Adt adt, WhereClause where_clause) {
  enum_where_clauses(adt, where_clause) or
  struct_where_clauses(adt, where_clause) or
  union_where_clauses(adt, where_clause)
}
