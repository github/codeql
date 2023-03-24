/**
 * @name unsigned to signed used in pointer arithmetic
 * @description finds unsigned to signed conversions used in pointer arithmetic, potentially causing an out-of-bound access
 * @id cpp/sign-conversion-pointer-arithmetic
 * @kind problem
 * @problem.severity warning
 * @tags reliability
 *       security
 *       experimental
 *       external/cwe/cwe-787
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.security.Overflow

from FunctionCall call, Function f, Parameter p, DataFlow::Node sink, PointerArithmeticOperation pao
where
  f = call.getTarget() and
  p = f.getAParameter() and
  p.getUnspecifiedType().(IntegralType).isSigned() and
  call.getArgument(p.getIndex()).getUnspecifiedType().(IntegralType).isUnsigned() and
  pao.getAnOperand() = sink.asExpr() and
  not guardedLesser(_, sink.asExpr()) and
  not guardedGreater(_, call.getArgument(p.getIndex())) and
  not call.getArgument(p.getIndex()).isConstant() and
  DataFlow::localFlow(DataFlow::parameterNode(p), sink) and
  p.getUnspecifiedType().getSize() < 8
select call,
  "This call passes an unsigned int to a function that requires a signed int: $@. It's then used in pointer arithmetic: $@.",
  f, f.toString(), sink, sink.toString()
