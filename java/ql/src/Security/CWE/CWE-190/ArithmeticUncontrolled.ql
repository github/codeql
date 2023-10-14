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
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.ArithmeticCommon
import semmle.code.java.security.ArithmeticUncontrolledQuery

module Flow =
  DataFlow::MergePathGraph<ArithmeticUncontrolledOverflowFlow::PathNode,
    ArithmeticUncontrolledUnderflowFlow::PathNode, ArithmeticUncontrolledOverflowFlow::PathGraph,
    ArithmeticUncontrolledUnderflowFlow::PathGraph>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, ArithExpr exp, string effect
where
  ArithmeticUncontrolledOverflowFlow::flowPath(source.asPathNode1(), sink.asPathNode1()) and
  overflowSink(exp, sink.getNode().asExpr()) and
  effect = "overflow"
  or
  ArithmeticUncontrolledUnderflowFlow::flowPath(source.asPathNode2(), sink.asPathNode2()) and
  underflowSink(exp, sink.getNode().asExpr()) and
  effect = "underflow"
select exp, source, sink,
  "This arithmetic expression depends on an $@, potentially causing an " + effect + ".",
  source.getNode(), "uncontrolled value"
