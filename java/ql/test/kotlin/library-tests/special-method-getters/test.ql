import java
import semmle.code.java.Diagnostics

from MethodAccess ma
select ma, ma.getCallee().getDeclaringType().getQualifiedName(), ma.getCallee().getName()

query predicate diag(Diagnostic d) { any() }
