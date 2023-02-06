class Expr extends @expr {
  string toString() { none() }
}

class Location extends @location_expr {
  string toString() { none() }
}

predicate isExprWithNewBuiltin(Expr expr) {
  exists(int kind | exprs(expr, kind, _) | 330 <= kind and kind <= 334)
}

from Expr expr, int kind, int kind_new, Location location
where
  exprs(expr, kind, location) and
  if isExprWithNewBuiltin(expr) then kind_new = 1 else kind_new = kind
select expr, kind_new, location
