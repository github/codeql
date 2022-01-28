// First we need to wrap some database types
class Location extends @location {
  /** Gets the start line of this location */
  int getStartLine() {
    locations_default(this, _, result, _, _, _) or
    locations_ast(this, _, result, _, _, _)
  }

  string toString() { result = "<some file>" + ":" + this.getStartLine().toString() }
}

class Expr_ extends @py_expr {
  string toString() { result = "Expr" }

  Location getLocation() { py_locations(result, this) }
}

class ExprParent_ extends @py_expr_parent {
  string toString() { result = "ExprParent" }
}

/**
 * New kinds have been inserted such that
 * `@py_Name` which used to have index 18 now has index 19.
 * Entries with lower indices are unchanged.
 */
bindingset[old_index]
int new_index(int old_index) {
  if old_index < 18 then result = old_index else result = (19 - 18) + old_index
}

// The schema for py_exprs is:
//
// py_exprs(unique int id : @py_expr,
//     int kind: int ref,
//     int parent : @py_expr_parent ref,
//     int idx : int ref);
from Expr_ expr, int old_kind, ExprParent_ parent, int idx, int new_kind
where
  py_exprs(expr, old_kind, parent, idx) and
  new_kind = new_index(old_kind)
select expr, new_kind, parent, idx
