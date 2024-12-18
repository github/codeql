class Expr extends @expr {
  string toString() { none() }
}

class Location extends @location_expr {
  string toString() { none() }
}

from Expr expr, int kind, int kind_new, Location loc
where
  exprs(expr, kind, loc) and
  if kind = 363 then kind_new = 1 else kind_new = kind
select expr, kind_new, loc
