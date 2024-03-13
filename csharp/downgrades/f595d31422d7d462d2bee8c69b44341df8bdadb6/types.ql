class Type extends @type {
  string toString() { none() }
}

from Type t, int k, int kind, string name
where
  types(t, k, name) and
  if k = 34 then kind = 15 else kind = k
select t, kind, name
