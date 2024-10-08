class Expr extends @expr {
  string toString() { none() }
}

class Type extends @type {
  string toString() { none() }
}

from Expr expr, Type type, int kind
where
  sizeof_bind(expr, type) and
  exprs(expr, kind, _) and
  (kind = 93 or kind = 94)
select expr, type
