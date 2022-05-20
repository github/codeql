import java

from UnaryExpr ue
where
  not exists(ue.getExpr())
  or
  exists(Expr e, int i | e.isNthChildOf(ue, i) and i != 0)
select ue
