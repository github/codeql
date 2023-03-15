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

private module ArithmeticTaintedLocalOverflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }
}

module ArithmeticTaintedLocalOverflowFlow =
  TaintTracking::Make<ArithmeticTaintedLocalOverflowConfig>;

private module ArithmeticTaintedLocalUnderflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }
}

module ArithmeticTaintedLocalUnderflowFlow =
  TaintTracking::Make<ArithmeticTaintedLocalUnderflowConfig>;

module Flow =
  DataFlow::MergePathGraph<ArithmeticTaintedLocalOverflowFlow::PathNode, ArithmeticTaintedLocalUnderflowFlow::PathNode, ArithmeticTaintedLocalOverflowFlow::PathGraph, ArithmeticTaintedLocalUnderflowFlow::PathGraph>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, ArithExpr exp, string effect
where
  ArithmeticTaintedLocalOverflowFlow::hasFlowPath(source.asPathNode1(), sink.asPathNode1()) and
  overflowSink(exp, sink.getNode().asExpr()) and
  effect = "overflow"
  or
  ArithmeticTaintedLocalUnderflowFlow::hasFlowPath(source.asPathNode2(), sink.asPathNode2()) and
  underflowSink(exp, sink.getNode().asExpr()) and
  effect = "underflow"
select exp, source, sink,
  "This arithmetic expression depends on a $@, potentially causing an " + effect + ".",
  source.getNode(), "user-provided value"
