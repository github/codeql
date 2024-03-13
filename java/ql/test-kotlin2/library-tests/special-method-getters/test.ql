import java
import semmle.code.java.Diagnostics

from MethodCall ma
select ma, ma.getCallee().getDeclaringType().getQualifiedName(), ma.getCallee().getName()

query predicate diag(Diagnostic d) { any() }
