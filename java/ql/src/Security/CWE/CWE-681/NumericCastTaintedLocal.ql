/**
 * @name Local-user-controlled data in numeric cast
 * @description Casting user-controlled numeric data to a narrower type without validation
 *              can cause unexpected truncation.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/tainted-numeric-cast-local
 * @tags security
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import java
import semmle.code.java.dataflow.FlowSources
import NumericCastCommon
import DataFlow::PathGraph

private class NumericCastFlowConfig extends TaintTracking::Configuration {
  NumericCastFlowConfig() {
    this = "NumericCastTaintedLocal::LocalUserInputToNumericNarrowingCastExpr"
  }

  override predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NumericNarrowingCastExpr cast).getExpr()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    boundedRead(node.asExpr()) or
    castCheck(node.asExpr()) or
    node.getType() instanceof SmallType or
    smallExpr(node.asExpr()) or
    node.getEnclosingCallable() instanceof HashCodeMethod
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, NumericNarrowingCastExpr exp,
  VarAccess tainted, NumericCastFlowConfig conf
where
  exp.getExpr() = tainted and
  sink.getNode().asExpr() = tainted and
  conf.hasFlowPath(source, sink) and
  not exists(RightShiftOp e | e.getShiftedVariable() = tainted.getVariable())
select exp, source, sink,
  "$@ flows to here and is cast to a narrower type, potentially causing truncation.",
  source.getNode(), "User-provided value"
