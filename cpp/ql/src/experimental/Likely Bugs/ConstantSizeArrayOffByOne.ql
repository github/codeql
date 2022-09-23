/**
 * @id cpp/constant-size-array-off-by-one
 * @kind path-problem
 */

import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import experimental.semmle.code.cpp.rangeanalysis.Bound
import experimental.semmle.code.cpp.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR
import experimental.semmle.code.cpp.ir.dataflow.DataFlow

from
  FieldAddressInstruction fai, PointerArithmeticInstruction pai, AddressOperand ao, ZeroBound b,
  int delta, int size
where
  size = fai.getField().getUnspecifiedType().(ArrayType).getArraySize() and
  DataFlow::localInstructionFlow(fai, pai.getLeft()) and
  DataFlow::localInstructionFlow(pai, ao.getAnyDef()) and
  semBounded(getSemanticExpr(pai.getRight()), b, delta, true, _) and
  delta >= size and
  size != 0 and // sometimes 0 or 1 is used for a variable-size array
  size != 1
select pai, "This pointer may have an off-by-" + (delta - size) + "error allowing it to overrun $@",
  fai.getField(), fai.getField().toString()
