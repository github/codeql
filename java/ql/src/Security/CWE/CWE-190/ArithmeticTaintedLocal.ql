/**
 * @name Local-user-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is not validated can cause
 *              overflows.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.6
 * @precision medium
 * @id java/tainted-arithmetic-local
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import java
import semmle.code.java.dataflow.FlowSources
import ArithmeticCommon
import DataFlow::PathGraph

class ArithmeticTaintedLocalOverflowConfig extends TaintTracking::Configuration {
  ArithmeticTaintedLocalOverflowConfig() { this = "ArithmeticTaintedLocalOverflowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node n) { overflowBarrier(n) }
}

class ArithmeticTaintedLocalUnderflowConfig extends TaintTracking::Configuration {
  ArithmeticTaintedLocalUnderflowConfig() { this = "ArithmeticTaintedLocalUnderflowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node n) { underflowBarrier(n) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, string effect
where
  any(ArithmeticTaintedLocalOverflowConfig c).hasFlowPath(source, sink) and
  overflowSink(exp, sink.getNode().asExpr()) and
  effect = "overflow"
  or
  any(ArithmeticTaintedLocalUnderflowConfig c).hasFlowPath(source, sink) and
  underflowSink(exp, sink.getNode().asExpr()) and
  effect = "underflow"
select exp, source, sink,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  source.getNode(), "User-provided value"
