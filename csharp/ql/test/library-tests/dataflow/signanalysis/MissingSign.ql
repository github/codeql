import csharp
import semmle.code.csharp.dataflow.internal.rangeanalysis.SignAnalysisCommon

from ControlFlow::Nodes::ExprNode e
where
  not exists(exprSign(e)) and
  not e.getExpr() instanceof TypeAccess and
  (
    e.getType() instanceof CharType or
    e.getType() instanceof IntegralType or
    e.getType() instanceof FloatingPointType or
    e.getType() instanceof DecimalType or
    e.getType() instanceof Enum or
    e.getType() instanceof PointerType
  )
select e
