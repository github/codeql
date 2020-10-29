import csharp
import semmle.code.csharp.dataflow.internal.rangeanalysis.RangeUtils
import semmle.code.csharp.dataflow.ModulusAnalysis
import semmle.code.csharp.dataflow.Bound

from ControlFlow::Nodes::ExprNode e, Bound b, int delta, int mod
where exprModulus(e, b, delta, mod)
select e, b.toString(), delta, mod
