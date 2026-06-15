class Type extends @type {
  string toString() { none() }
}

from Type type, string name, int kind, int new_kind, Type type_id
where
  derivedtypes(type, name, kind, type_id) and
  if kind = 11 then /* @gnu_vector */ new_kind = 5 else new_kind = kind
select type, name, new_kind, type_id
