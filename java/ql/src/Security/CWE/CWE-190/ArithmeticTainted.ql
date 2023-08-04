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
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.ArithmeticCommon
import semmle.code.java.security.ArithmeticTaintedQuery

module Flow =
  DataFlow::MergePathGraph<RemoteUserInputOverflow::PathNode, RemoteUserInputUnderflow::PathNode,
    RemoteUserInputOverflow::PathGraph, RemoteUserInputUnderflow::PathGraph>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, ArithExpr exp, string effect
where
  RemoteUserInputOverflow::flowPath(source.asPathNode1(), sink.asPathNode1()) and
  overflowSink(exp, sink.getNode().asExpr()) and
  effect = "overflow"
  or
  RemoteUserInputUnderflow::flowPath(source.asPathNode2(), sink.asPathNode2()) and
  underflowSink(exp, sink.getNode().asExpr()) and
  effect = "underflow"
select exp, source, sink,
  "This arithmetic expression depends on a $@, potentially causing an " + effect + ".",
  source.getNode(), "user-provided value"
