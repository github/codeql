/**
 * @name Local-user-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is not validated can cause
 *              overflows.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/tainted-arithmetic-local
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */
import java
import semmle.code.java.dataflow.FlowSources
import ArithmeticCommon

predicate sink(ArithExpr exp, VarAccess tainted, string effect) {
  exp.getAnOperand() = tainted and
  (
    not guardedAgainstUnderflow(exp, tainted) and effect = "underflow" or
    not guardedAgainstOverflow(exp, tainted) and effect = "overflow"
  ) and
  // Exclude widening conversions of tainted values due to binary numeric promotion (JLS 5.6.2)
  // unless there is an enclosing cast down to a narrower type.
  narrowerThanOrEqualTo(exp, tainted.getType()) and
  not overflowIrrelevant(exp)
}

class ArithmeticTaintedLocalFlowConfig extends TaintTracking::Configuration {
  ArithmeticTaintedLocalFlowConfig() { this = "ArithmeticTaintedLocalFlowConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }
  override predicate isSink(DataFlow::Node sink) { sink(_, sink.asExpr(), _) }
  override predicate isSanitizer(DataFlow::Node n) { n.getType() instanceof BooleanType }
}

from ArithExpr exp, VarAccess tainted, LocalUserInput origin, string effect
where
  any(ArithmeticTaintedLocalFlowConfig conf).hasFlow(origin, DataFlow::exprNode(tainted)) and
  sink(exp, tainted, effect)
select exp, "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  origin, "User-provided value"
