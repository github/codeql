class Expr_ extends @expr {
  string toString() { result = "Expr" }
}

class ExprParent_ extends @exprparent {
  string toString() { result = "ExprParent" }
}

/**
 * The last index, 55 (errorexpr), has been deleted. Index 0 (badexpr) should
 * be used instead.
 */
bindingset[old_index]
int new_index(int old_index) {
  if old_index = 55
  then result = 0 // badexpr
  else result = old_index
}

// The schema for exprs is:
//
// exprs(unique int id: @expr,
//     int kind: int ref,
//     int parent: @exprparent ref,
//     int idx: int ref);
from Expr_ expr, int new_kind, ExprParent_ parent, int idx, int old_kind
where exprs(expr, old_kind, parent, idx) and new_kind = new_index(old_kind)
select expr, new_kind, parent, idx
