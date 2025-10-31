class KeyPathComponent extends @key_path_component {
  string toString() { none() }
}

class TypeOrNone extends @type_or_none {
  string toString() { none() }
}

from KeyPathComponent id, int kind, int new_kind, TypeOrNone component_type
where
  key_path_components(id, kind, component_type) and
  if kind = 0
  then new_kind = kind
  else
    if kind = 1 or kind = 2
    then new_kind = kind + 1
    else new_kind = kind + 2
select id, new_kind, component_type
