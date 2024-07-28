import java
import semmle.code.java.dataflow.TypeFlow

from VarRead e, RefType t, boolean exact
where exprTypeFlow(e, t, exact)
select e, t.toString(), exact
