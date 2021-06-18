/**
 * @name User-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is
 *              not validated can cause overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.9
 * @precision low
 * @id cpp/tainted-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

bindingset[op]
predicate missingGuard(Operation op, Expr e, string effect) {
  missingGuardAgainstUnderflow(op, e) and effect = "underflow"
  or
  missingGuardAgainstOverflow(op, e) and effect = "overflow"
  or
  not e instanceof VariableAccess and effect = "overflow"
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element e) {
    exists(Operation op |
      missingGuard(op, e, _) and
      op.getAnOperand() = e
    |
      op instanceof UnaryArithmeticOperation or
      op instanceof BinaryArithmeticOperation
    )
  }
}

from Expr origin, Expr e, string effect, PathNode sourceNode, PathNode sinkNode, Operation op
where
  taintedWithPath(origin, e, sourceNode, sinkNode) and
  op.getAnOperand() = e and
  missingGuard(op, e, effect)
select e, sourceNode, sinkNode,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".", origin,
  "User-provided value"
