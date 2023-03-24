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

module NumericCastFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NumericNarrowingCastExpr cast).getExpr() and
    sink.asExpr() instanceof VarAccess
  }

  predicate isBarrier(DataFlow::Node node) {
    boundedRead(node.asExpr()) or
    castCheck(node.asExpr()) or
    node.getType() instanceof SmallType or
    smallExpr(node.asExpr()) or
    node.getEnclosingCallable() instanceof HashCodeMethod or
    exists(RightShiftOp e | e.getShiftedVariable().getAnAccess() = node.asExpr())
  }
}

module NumericCastFlow = TaintTracking::Global<NumericCastFlowConfig>;

import NumericCastFlow::PathGraph

from NumericCastFlow::PathNode source, NumericCastFlow::PathNode sink, NumericNarrowingCastExpr exp
where
  sink.getNode().asExpr() = exp.getExpr() and
  NumericCastFlow::flowPath(source, sink)
select exp, source, sink,
  "This cast to a narrower type depends on a $@, potentially causing truncation.", source.getNode(),
  "user-provided value"
