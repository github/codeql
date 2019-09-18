/**
 * @name Uncontrolled data in arithmetic expression
 * @description Arithmetic operations on uncontrolled data that is not validated can cause
 *              overflows.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/uncontrolled-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SecurityTests
import ArithmeticCommon
import DataFlow::PathGraph

class TaintSource extends DataFlow::ExprNode {
  TaintSource() {
    // Either this is an access to a random number generating method of the right kind, ...
    exists(Method def |
      def = this.getExpr().(MethodAccess).getMethod() and
      (
        // Some random-number methods are omitted:
        // `nextDouble` and `nextFloat` are between 0 and 1,
        // `nextGaussian` is extremely unlikely to hit max values.
        def.getName() = "nextInt" or
        def.getName() = "nextLong"
      ) and
      def.getNumberOfParameters() = 0 and
      def.getDeclaringType().hasQualifiedName("java.util", "Random")
    )
    or
    // ... or this is the array parameter of `nextBytes`, which is filled with random bytes.
    exists(MethodAccess m, Method def |
      m.getAnArgument() = this.getExpr() and
      m.getMethod() = def and
      def.getName() = "nextBytes" and
      def.getNumberOfParameters() = 1 and
      def.getDeclaringType().hasQualifiedName("java.util", "Random")
    )
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
