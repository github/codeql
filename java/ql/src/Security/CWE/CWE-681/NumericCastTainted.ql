/**
 * @name User-controlled data in numeric cast
 * @description Casting user-controlled numeric data to a narrower type without validation
 *              can cause unexpected truncation.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id java/tainted-numeric-cast
 * @tags security
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import java
import semmle.code.java.dataflow.FlowSources
import NumericCastCommon
import DataFlow::PathGraph

private class NumericCastFlowConfig extends TaintTracking::Configuration {
  NumericCastFlowConfig() { this = "NumericCastTainted::RemoteUserInputToNumericNarrowingCastExpr" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NumericNarrowingCastExpr cast).getExpr() and
    sink.asExpr() instanceof VarAccess
  }

  override predicate isSanitizer(DataFlow::Node node) {
    boundedRead(node.asExpr()) or
    castCheck(node.asExpr()) or
    node.getType() instanceof SmallType or
    smallExpr(node.asExpr()) or
    node.getEnclosingCallable() instanceof HashCodeMethod or
    exists(RightShiftOp e | e.getShiftedVariable().getAnAccess() = node.asExpr())
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, NumericNarrowingCastExpr exp,
  NumericCastFlowConfig conf
where
  sink.getNode().asExpr() = exp.getExpr() and
  conf.hasFlowPath(source, sink)
select exp, source, sink,
  "This cast to a narrower type depends on a $@, potentially causing truncation.", source.getNode(),
  "user-provided value"
