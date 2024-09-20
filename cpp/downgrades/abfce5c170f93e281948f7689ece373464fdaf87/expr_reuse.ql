class Expr extends @expr {
  string toString() { none() }
}

from Expr reuse, Expr original
where expr_reuse(reuse, original, _)
select reuse, original
