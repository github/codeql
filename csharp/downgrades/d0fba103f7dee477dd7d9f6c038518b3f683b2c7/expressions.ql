class Expression extends @expr {
  string toString() { none() }
}

class TypeOrRef extends @type_or_ref {
  string toString() { none() }
}

from Expression e, int k, int kind, TypeOrRef t
where
  expressions(e, k, t) and
  if k = [133, 134] then kind = 106 else kind = k
select e, kind, t
