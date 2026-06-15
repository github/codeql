class BuiltinType extends @builtintype {
  string toString() { none() }
}

from BuiltinType id, string name, int kind, int new_kind, int size, int sign, int alignment
where
  builtintypes(id, name, kind, size, sign, alignment) and
  if kind = 63 then /* @errortype */ new_kind = 1 else new_kind = kind
select id, name, new_kind, size, sign, alignment
