import java

query predicate classExprs(Expr e, string tstr) {
  exists(e.getFile().getRelativePath()) and
  tstr = e.getType().toString() and
  tstr.contains("Class")
}

from Method m
where m.getDeclaringType().fromSource()
select m, m.getReturnType().toString()
