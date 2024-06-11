import java
import semmle.code.java.Diagnostics

query predicate diagnostics(Diagnostic d) { any() }

from Class c
where c.getName() = "DepClass"
select c.toString()
