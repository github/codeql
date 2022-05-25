import java
import semmle.code.java.Diagnostics

from MethodAccess ma
select ma.getCallee().getAParameter().getType().toString()

query predicate diagnostics(Diagnostic d) { any() }
