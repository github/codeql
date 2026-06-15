import java

query predicate exprs(Expr e, string t) {
  e.getEnclosingCallable().getDeclaringType().fromSource() and t = e.getType().toString()
}

from Method m
where m.fromSource()
select m, m.getAParamType().toString()
