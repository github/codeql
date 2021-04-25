import java
import semmle.code.java.dataflow.NullGuards

from Expr notNull, Expr reason
where
  notNull = clearlyNotNullExpr(reason) and
  // Restrict to ArrayInit to make results easier to read
  notNull.getParent() instanceof ArrayInit
select notNull, reason
