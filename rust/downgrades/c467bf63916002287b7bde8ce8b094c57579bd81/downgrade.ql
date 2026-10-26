class Element extends @element {
  string toString() { none() }
}

class Enum extends Element, @enum { }

class Struct extends Element, @struct { }

class Union extends Element, @union { }

class Attr extends Element, @attr { }

class GenericParamList extends Element, @generic_param_list { }

class Name extends Element, @name { }

class Visibility extends Element, @visibility { }

class WhereClause extends Element, @where_clause { }

query predicate new_enum_attrs(Enum enum, int index, Attr attr) {
  type_item_attrs(enum, index, attr)
}

query predicate new_enum_generic_param_lists(Enum enum, GenericParamList g) {
  type_item_generic_param_lists(enum, g)
}

query predicate new_enum_names(Enum enum, Name name) { type_item_names(enum, name) }

query predicate new_enum_visibilities(Enum enum, Visibility visibility) {
  type_item_visibilities(enum, visibility)
}

query predicate new_enum_where_clauses(Enum enum, WhereClause whereClause) {
  type_item_where_clauses(enum, whereClause)
}

query predicate new_struct_attrs(Struct struct, int index, Attr attr) {
  type_item_attrs(struct, index, attr)
}

query predicate new_struct_generic_param_lists(Struct struct, GenericParamList g) {
  type_item_generic_param_lists(struct, g)
}

query predicate new_struct_names(Struct struct, Name name) { type_item_names(struct, name) }

query predicate new_struct_visibilities(Struct struct, Visibility visibility) {
  type_item_visibilities(struct, visibility)
}

query predicate new_struct_where_clauses(Struct struct, WhereClause whereClause) {
  type_item_where_clauses(struct, whereClause)
}

query predicate new_union_attrs(Union union, int index, Attr attr) {
  type_item_attrs(union, index, attr)
}

query predicate new_union_generic_param_lists(Union union, GenericParamList g) {
  type_item_generic_param_lists(union, g)
}

query predicate new_union_names(Union union, Name name) { type_item_names(union, name) }

query predicate new_union_visibilities(Union union, Visibility visibility) {
  type_item_visibilities(union, visibility)
}

query predicate new_union_where_clauses(Union union, WhereClause whereClause) {
  type_item_where_clauses(union, whereClause)
}
