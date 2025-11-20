import java
import semmle.code.java.dataflow.SSA

from SsaCapturedDefinition closure, SsaDefinition captured
where closure.captures(captured)
select closure, captured
