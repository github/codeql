import csharp
import semmle.code.csharp.dataflow.internal.rangeanalysis.RangeUtils
import semmle.code.csharp.dataflow.ModulusAnalysis
import semmle.code.csharp.dataflow.Bound

from ControlFlow::Nodes::ExprNode e, Bound b, QlBuiltins::BigInt delta, QlBuiltins::BigInt mod
where
  not e.getExpr().fromLibrary() and
  exprModulus(e, b, delta, mod)
select e, b.toString(), delta.toString(), mod.toString()
