/**
 * @name Uncontrolled data in arithmetic expression
 * @description Arithmetic operations on uncontrolled data that is not
 *              validated can cause overflows.
 * @kind path-problem
 * @problem.severity warning
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

predicate isRandCall(FunctionCall fc) { fc.getTarget().getName() = "rand" }

predicate isRandCallOrParent(Expr e) {
  isRandCall(e) or
  isRandCallOrParent(e.getAChild())
}

predicate isRandValue(Expr e) {
  isRandCall(e)
  or
  exists(MacroInvocation mi |
    e = mi.getExpr() and
    isRandCallOrParent(e)
  )
}

class SecurityOptionsArith extends SecurityOptions {
  override predicate isUserInput(Expr expr, string cause) {
    isRandValue(expr) and
    cause = "rand" and
    not expr.getParent*() instanceof DivExpr
  }
}

predicate isDiv(VariableAccess va) { exists(AssignDivExpr div | div.getLValue() = va) }

predicate missingGuard(VariableAccess va, string effect) {
  exists(Operation op | op.getAnOperand() = va |
    missingGuardAgainstUnderflow(op, va) and effect = "underflow"
    or
    missingGuardAgainstOverflow(op, va) and effect = "overflow"
  )
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element e) {
    isDiv(e)
    or
    missingGuard(e, _)
  }
}

/**
 * A value that undergoes division is likely to be bounded within a safe
 * range.
 */
predicate guardedByAssignDiv(Expr origin) {
  exists(VariableAccess va |
    taintedWithPath(origin, va, _, _) and
    isDiv(va)
  )
}

from Expr origin, VariableAccess va, string effect, PathNode sourceNode, PathNode sinkNode
where
  taintedWithPath(origin, va, sourceNode, sinkNode) and
  missingGuard(va, effect) and
  not guardedByAssignDiv(origin)
select va, sourceNode, sinkNode,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".", origin,
  "Uncontrolled value"
