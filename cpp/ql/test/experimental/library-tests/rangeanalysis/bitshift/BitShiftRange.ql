import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import experimental.semmle.code.cpp.rangeanalysis.extensions.ConstantShiftExprRange

Expr getLOp(Operation o) {
  result = o.(BinaryOperation).getLeftOperand() or
  result = o.(Assignment).getLValue()
}

Expr getROp(Operation o) {
  result = o.(BinaryOperation).getRightOperand() or
  result = o.(Assignment).getRValue()
}

from Operation o
where
  (
    o instanceof BinaryBitwiseOperation
    or
    o instanceof AssignBitwiseOperation
  )
select o, lowerBound(o), upperBound(o), getLOp(o).getUnderlyingType(),
  getROp(o).getUnderlyingType(), getLOp(o).getFullyConverted().getUnderlyingType(),
  getROp(o).getFullyConverted().getUnderlyingType()
