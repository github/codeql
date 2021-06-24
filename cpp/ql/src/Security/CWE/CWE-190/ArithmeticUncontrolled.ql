/**
 * @name Uncontrolled data in arithmetic expression
 * @description Arithmetic operations on uncontrolled data that is not
 *              validated can cause overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.6
 * @precision medium
 * @id cpp/uncontrolled-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath
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

predicate isUnboundedRandCall(FunctionCall fc) {
  exists(Function func | func = fc.getTarget() |
    func.hasGlobalOrStdOrBslName("rand") and
    not bounded(fc) and
    func.getNumberOfParameters() = 0
  )
}

predicate isUnboundedRandCallOrParent(Expr e) {
  isUnboundedRandCall(e)
  or
  isUnboundedRandCallOrParent(e.getAChild())
}

predicate isUnboundedRandValue(Expr e) {
  isUnboundedRandCall(e)
  or
  exists(MacroInvocation mi |
    e = mi.getExpr() and
    isUnboundedRandCallOrParent(e)
  )
}

class SecurityOptionsArith extends SecurityOptions {
  override predicate isUserInput(Expr expr, string cause) {
    isUnboundedRandValue(expr) and
    cause = "rand"
  }
}

predicate missingGuard(VariableAccess va, string effect) {
  exists(Operation op | op.getAnOperand() = va |
    missingGuardAgainstUnderflow(op, va) and effect = "underflow"
    or
    missingGuardAgainstOverflow(op, va) and effect = "overflow"
  )
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element e) { missingGuard(e, _) }

  override predicate isBarrier(Expr e) { super.isBarrier(e) or bounded(e) }
}

from Expr origin, VariableAccess va, string effect, PathNode sourceNode, PathNode sinkNode
where
  taintedWithPath(origin, va, sourceNode, sinkNode) and
  missingGuard(va, effect)
select va, sourceNode, sinkNode,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".", origin,
  "Uncontrolled value"
