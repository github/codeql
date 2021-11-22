import java

from AnonymousClass c, KtAnonymousClassDeclarationStmt stmt
where c.fromSource() and stmt.getDeclaration() = c
select c, c.getClassInstanceExpr(),
  c.getClassInstanceExpr().getConstructor().getDeclaringType().getName(),
  c.getClassInstanceExpr().getTypeName(), stmt
