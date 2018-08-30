import java
import semmle.code.java.Reflection

from Type inferredType, Expr expr
where inferredType = inferClassParameterType(expr) and inferredType.fromSource()
select inferredType, expr
