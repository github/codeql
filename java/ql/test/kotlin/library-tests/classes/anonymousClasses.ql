import java

from AnonymousClass c
where c.fromSource()
select c, c.getClassInstanceExpr(),
  c.getClassInstanceExpr().getConstructor().getDeclaringType().getName(),
  c.getClassInstanceExpr().getTypeName()
