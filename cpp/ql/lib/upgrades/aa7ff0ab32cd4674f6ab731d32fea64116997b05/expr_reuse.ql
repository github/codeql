class Expr extends @expr {
  string toString() { none() }
}

from Expr reuse, Expr original, int value_category
where expr_reuse(reuse, original) and expr_types(original, _, value_category)
select reuse, original, value_category
