class Type extends @type {
  string toString() { none() }
}

predicate derivedType(Type type, string name, int kind, Type type_id) {
  derivedtypes(type, name, kind, type_id)
}

predicate typeTransformation(Type type, string name, int kind, Type type_id) {
  type_operators(type, _, _, type_id) and
  name = "" and
  kind = 3 // @type_with_specifiers
}

from Type type, string name, int kind, Type type_id
where
  derivedType(type, name, kind, type_id) or
  typeTransformation(type, name, kind, type_id)
select type, name, kind, type_id
