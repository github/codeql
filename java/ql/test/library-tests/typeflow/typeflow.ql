import java
import semmle.code.java.dataflow.TypeFlow

from RValue e, RefType t, boolean exact
where exprTypeFlow(e, t, exact)
select e, t.toString(), exact
