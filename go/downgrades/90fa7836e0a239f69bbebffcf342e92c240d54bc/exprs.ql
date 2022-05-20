class Expr_ extends @expr {
  string toString() { result = "Expr" }
}

class ExprParent_ extends @exprparent {
  string toString() { result = "ExprParent" }
}

/**
 * Two new kinds have been inserted such that `@sliceexpr` which used to have
 * index 13 now has index 15. Another new kind has been inserted such that
 * `@plusexpr` which used to have index 23 now has index 26. Entries with
 * indices lower than 13 are unchanged.
 */
bindingset[new_index]
int old_index(int new_index) {
  if new_index < 13
  then result = new_index
  else
    if new_index = [13, 14]
    then result = 0 // badexpr
    else
      if new_index < 23
      then result + (15 - 13) = new_index
      else
        if new_index = 23
        then result = 0 // badexpr
        else result + (26 - 23) = new_index
}

// The schema for exprs is:
//
// exprs(unique int id: @expr,
//     int kind: int ref,
//     int parent: @exprparent ref,
//     int idx: int ref);
from Expr_ expr, int new_kind, ExprParent_ parent, int idx, int old_kind
where
  exprs(expr, new_kind, parent, idx) and
  old_kind = old_index(new_kind)
select expr, old_kind, parent, idx
