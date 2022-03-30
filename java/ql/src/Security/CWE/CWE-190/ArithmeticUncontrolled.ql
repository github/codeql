/**
 * @name Uncontrolled data in arithmetic expression
 * @description Arithmetic operations on uncontrolled data that is not validated can cause
 *              overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.6
 * @precision medium
 * @id java/uncontrolled-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.RandomQuery
import semmle.code.java.security.SecurityTests
import ArithmeticCommon
import DataFlow::PathGraph

class TaintSource extends DataFlow::ExprNode {
  TaintSource() {
    exists(RandomDataSource m | not m.resultMayBeBounded() | m.getOutput() = this.getExpr())
  }
}

class ArithmeticUncontrolledOverflowConfig extends TaintTracking::Configuration {
  ArithmeticUncontrolledOverflowConfig() { this = "ArithmeticUncontrolledOverflowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof TaintSource }

  override predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node n) { overflowBarrier(n) }
}

class ArithmeticUncontrolledUnderflowConfig extends TaintTracking::Configuration {
  ArithmeticUncontrolledUnderflowConfig() { this = "ArithmeticUncontrolledUnderflowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof TaintSource }

  override predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node n) { underflowBarrier(n) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, string effect
where
  any(ArithmeticUncontrolledOverflowConfig c).hasFlowPath(source, sink) and
  overflowSink(exp, sink.getNode().asExpr()) and
  effect = "overflow"
  or
  any(ArithmeticUncontrolledUnderflowConfig c).hasFlowPath(source, sink) and
  underflowSink(exp, sink.getNode().asExpr()) and
  effect = "underflow"
select exp, source, sink,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  source.getNode(), "Uncontrolled value"
