/**
 * @name Local-user-controlled data in numeric cast
 * @description Casting user-controlled numeric data to a narrower type without validation
 *              can cause unexpected truncation.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 9.0
 * @precision medium
 * @id java/tainted-numeric-cast-local
 * @tags security
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import java
import semmle.code.java.dataflow.FlowSources
import NumericCastCommon

module NumericCastFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NumericNarrowingCastExpr cast).getExpr()
  }

  predicate isBarrier(DataFlow::Node node) {
    boundedRead(node.asExpr()) or
    castCheck(node.asExpr()) or
    node.getType() instanceof SmallType or
    smallExpr(node.asExpr()) or
    node.getEnclosingCallable() instanceof HashCodeMethod
  }
}

module NumericCastFlow = TaintTracking::Global<NumericCastFlowConfig>;

import NumericCastFlow::PathGraph

from
  NumericCastFlow::PathNode source, NumericCastFlow::PathNode sink, NumericNarrowingCastExpr exp,
  VarAccess tainted
where
  exp.getExpr() = tainted and
  sink.getNode().asExpr() = tainted and
  NumericCastFlow::flowPath(source, sink) and
  not exists(RightShiftOp e | e.getShiftedVariable() = tainted.getVariable())
select exp, source, sink,
  "This cast to a narrower type depends on a $@, potentially causing truncation.", source.getNode(),
  "user-provided value"
