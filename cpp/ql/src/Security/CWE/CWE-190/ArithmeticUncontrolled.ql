/**
 * @name Uncontrolled data in arithmetic expression
 * @description Arithmetic operations on uncontrolled data that is not
 *              validated can cause overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.6
 * @precision high
 * @id cpp/uncontrolled-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import DataFlow::PathGraph
import Bounded

/**
 * A function that outputs random data such as `std::rand`.
 */
abstract class RandomFunction extends Function {
  /**
   * Gets the `FunctionOutput` that describes how this function returns the random data.
   */
  FunctionOutput getFunctionOutput() { result.isReturnValue() }
}

/**
 * The standard function `std::rand`.
 */
private class StdRand extends RandomFunction {
  StdRand() {
    this.hasGlobalOrStdOrBslName("rand") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The Unix function `rand_r`.
 */
private class RandR extends RandomFunction {
  RandR() {
    this.hasGlobalName("rand_r") and
    this.getNumberOfParameters() = 1
  }
}

/**
 * The Unix function `random`.
 */
private class Random extends RandomFunction {
  Random() {
    this.hasGlobalName("random") and
    this.getNumberOfParameters() = 1
  }
}

/**
 * The Windows `rand_s` function.
 */
private class RandS extends RandomFunction {
  RandS() {
    this.hasGlobalName("rand_s") and
    this.getNumberOfParameters() = 1
  }

  override FunctionOutput getFunctionOutput() { result.isParameterDeref(0) }
}

predicate missingGuard(VariableAccess va, string effect) {
  exists(Operation op | op.getAnOperand() = va |
    // underflow - random numbers are usually non-negative, so underflow is
    // only likely if the type is unsigned. Multiplication is also unlikely to
    // cause underflow of a non-negative number.
    missingGuardAgainstUnderflow(op, va) and
    effect = "underflow" and
    op.getUnspecifiedType().(IntegralType).isUnsigned() and
    not op instanceof MulExpr
    or
    // overflow - only report signed integer overflow since unsigned overflow
    // is well-defined.
    op.getUnspecifiedType().(IntegralType).isSigned() and
    missingGuardAgainstOverflow(op, va) and
    effect = "overflow"
  )
}

class UncontrolledArithConfiguration extends TaintTracking::Configuration {
  UncontrolledArithConfiguration() { this = "UncontrolledArithConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(RandomFunction rand, Call call | call.getTarget() = rand |
      rand.getFunctionOutput().isReturnValue() and
      source.asExpr() = call
      or
      exists(int n |
        source.asDefiningArgument() = call.getArgument(n) and
        rand.getFunctionOutput().isParameterDeref(n)
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) { missingGuard(sink.asExpr(), _) }

  override predicate isSanitizer(DataFlow::Node node) {
    bounded(node.asExpr())
    or
    // If this expression is part of bitwise 'and' or 'or' operation it's likely that the value is
    // only used as a bit pattern.
    node.asExpr() =
      any(Operation op |
        op instanceof BitwiseOrExpr or
        op instanceof BitwiseAndExpr or
        op instanceof ComplementExpr
      ).getAnOperand*()
    or
    // block unintended flow to pointers
    node.asExpr().getUnspecifiedType() instanceof PointerType
  }
}

/** Gets the expression that corresponds to `node`, if any. */
Expr getExpr(DataFlow::Node node) { result = [node.asExpr(), node.asDefiningArgument()] }

from
  UncontrolledArithConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  VariableAccess va, string effect
where
  config.hasFlowPath(source, sink) and
  sink.getNode().asExpr() = va and
  missingGuard(va, effect)
select sink.getNode(), source, sink,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  getExpr(source.getNode()), "Uncontrolled value"
