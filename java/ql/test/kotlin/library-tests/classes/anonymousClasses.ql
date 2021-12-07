import java

from AnonymousClass c, LocalTypeDeclStmt stmt
where c.fromSource() and stmt.getLocalType() = c
select c, c.getClassInstanceExpr(),
  c.getClassInstanceExpr().getConstructor().getDeclaringType().getName(),
  c.getClassInstanceExpr().getTypeName(), stmt
