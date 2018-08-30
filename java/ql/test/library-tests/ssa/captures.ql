import java
import semmle.code.java.dataflow.SSA

from SsaImplicitInit closure, SsaVariable captured
where closure.captures(captured)
select closure, captured
