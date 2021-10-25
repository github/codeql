import cpp

from Function f
select f, count(Expr e | f = e.getEnclosingFunction()),
  count(ErrorExpr e | f = e.getEnclosingFunction())
