import java

query predicate classExprs(Expr e, string tstr) {
  tstr = e.getType().toString() and
  tstr.matches("%Class%")
}

from Method m
where m.getDeclaringType().fromSource()
select m, m.getReturnType().toString()
