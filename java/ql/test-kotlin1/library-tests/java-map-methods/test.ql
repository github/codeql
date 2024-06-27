import java
import semmle.code.java.Diagnostics

from MethodCall ma
select ma.getCallee().getAParameter().getType().toString()

query predicate diagnostics(Diagnostic d) { any() }
