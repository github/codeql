/**
 * @name User-controlled data in numeric cast
 * @description Casting user-controlled numeric data to a narrower type without validation
 *              can cause unexpected truncation.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/tainted-numeric-cast
 * @tags security
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */
import java
import semmle.code.java.dataflow.FlowSources
import NumericCastCommon

private class NumericCastFlowConfig extends TaintTracking::Configuration {
  NumericCastFlowConfig() { this = "NumericCastTainted::RemoteUserInputToNumericNarrowingCastExpr" }
  override predicate isSource(DataFlow::Node src) { src instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(NumericNarrowingCastExpr cast).getExpr() }
  override predicate isSanitizer(DataFlow::Node node) {
    boundedRead(node.asExpr()) or
    castCheck(node.asExpr()) or
    node.getType() instanceof SmallType or
    smallExpr(node.asExpr()) or
    node.getEnclosingCallable() instanceof HashCodeMethod
  }
}

from NumericNarrowingCastExpr exp, VarAccess tainted, RemoteUserInput origin, NumericCastFlowConfig conf
where
  exp.getExpr() = tainted and
  conf.hasFlow(origin, DataFlow::exprNode(tainted)) and
  not exists(RightShiftOp e | e.getShiftedVariable() = tainted.getVariable())
select exp, "$@ flows to here and is cast to a narrower type, potentially causing truncation.",
  origin, "User-provided value"
