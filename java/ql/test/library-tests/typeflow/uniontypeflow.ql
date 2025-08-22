import java
import semmle.code.java.dataflow.TypeFlow

int countUnionTypes(Expr e) {
  result = strictcount(RefType t, boolean exact | exprUnionTypeFlow(e, t, exact))
}

from VarRead e, RefType t, boolean exact
where exprUnionTypeFlow(e, t, exact)
select e, countUnionTypes(e), t.toString(), exact
