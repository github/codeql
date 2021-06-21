/**
 * @name User-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is not validated can cause
 *              overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.6
 * @precision medium
 * @id java/tainted-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import java
import semmle.code.java.dataflow.FlowSources
import ArithmeticCommon
import DataFlow::PathGraph

class RemoteUserInputOverflowConfig extends TaintTracking::Configuration {
  RemoteUserInputOverflowConfig() { this = "ArithmeticTainted.ql:RemoteUserInputOverflowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node n) { overflowBarrier(n) }
}

class RemoteUserInputUnderflowConfig extends TaintTracking::Configuration {
  RemoteUserInputUnderflowConfig() { this = "ArithmeticTainted.ql:RemoteUserInputUnderflowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node n) { underflowBarrier(n) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, string effect
where
  any(RemoteUserInputOverflowConfig c).hasFlowPath(source, sink) and
  overflowSink(exp, sink.getNode().asExpr()) and
  effect = "overflow"
  or
  any(RemoteUserInputUnderflowConfig c).hasFlowPath(source, sink) and
  underflowSink(exp, sink.getNode().asExpr()) and
  effect = "underflow"
select exp, source, sink,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  source.getNode(), "User-provided value"
