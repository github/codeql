import java
import semmle.code.java.dataflow.ModulusAnalysis
import semmle.code.java.dataflow.Bound

from Expr e, Bound b, QlBuiltins::BigInt delta, QlBuiltins::BigInt mod
where exprModulus(e, b, delta, mod) and e.getCompilationUnit().fromSource()
select e, b.toString(), delta.toString(), mod.toString()
