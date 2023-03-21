import csharp
import semmle.code.csharp.dataflow.internal.rangeanalysis.SignAnalysisCommon as Common

from ControlFlow::Nodes::ExprNode e, Expr expr
where
  e.getExpr() = expr and
  expr.getFile().getStem() = "SignAnalysis" and
  expr instanceof UnsignedRightShiftExpr
select e, strictconcat(string s | s = Common::exprSign(e).toString() | s, " ")
