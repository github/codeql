import cpp

from Type t, Function f, Expr e
where
  t = f.getDeclaringType() and
  f = e.getEnclosingFunction()
select t, f, e
