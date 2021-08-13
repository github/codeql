/**
 * @name User-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is
 *              not validated can cause overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.6
 * @precision low
 * @id cpp/tainted-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import DataFlow::PathGraph
import Bounded

bindingset[op]
predicate missingGuard(Operation op, Expr e, string effect) {
  missingGuardAgainstUnderflow(op, e) and effect = "underflow"
  or
  missingGuardAgainstOverflow(op, e) and effect = "overflow"
  or
  not e instanceof VariableAccess and effect = "overflow"
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ArithmeticTaintedConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(Operation op |
      missingGuard(op, sink.asExpr(), _) and
      op.getAnOperand() = sink.asExpr()
    |
      op instanceof UnaryArithmeticOperation or
      op instanceof BinaryArithmeticOperation
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Expr e | e = node.asExpr() |
      bounded(e) or e.getUnspecifiedType().(IntegralType).getSize() <= 1
    )
  }
}

from
  Expr origin, Expr e, string effect, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  Operation op, Configuration conf
where
  conf.hasFlowPath(sourceNode, sinkNode) and
  sourceNode.getNode().asExpr() = origin and
  sinkNode.getNode().asExpr() = e and
  op.getAnOperand() = e and
  missingGuard(op, e, effect)
select e, sourceNode, sinkNode,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".", origin,
  "User-provided value"
