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

predicate sink(ArithExpr exp, VarAccess tainted, string effect) {
  exp.getAnOperand() = tainted and
  (
    not guardedAgainstUnderflow(exp, tainted) and effect = "underflow"
    or
    not guardedAgainstOverflow(exp, tainted) and effect = "overflow"
  ) and
  // Exclude widening conversions of tainted values due to binary numeric promotion (JLS 5.6.2)
  // unless there is an enclosing cast down to a narrower type.
  narrowerThanOrEqualTo(exp, tainted.getType()) and
  not overflowIrrelevant(exp) and
  not exp.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass
}

class ArithmeticUncontrolledFlowConfig extends TaintTracking::Configuration {
  ArithmeticUncontrolledFlowConfig() { this = "ArithmeticUncontrolledFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof TaintSource }

  override predicate isSink(DataFlow::Node sink) { sink(_, sink.asExpr(), _) }

  override predicate isSanitizer(DataFlow::Node n) { n.getType() instanceof BooleanType }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, string effect,
  ArithmeticUncontrolledFlowConfig conf
where
  conf.hasFlowPath(source, sink) and
  sink(exp, sink.getNode().asExpr(), effect)
select exp, source, sink,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  source.getNode(), "Uncontrolled value"
