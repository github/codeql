import java
import semmle.code.java.dataflow.ModulusAnalysis
import semmle.code.java.dataflow.Bound

from Expr e, Bound b, int delta, int mod
where exprModulus(e, b, delta, mod)
select e, b.toString(), delta, mod
