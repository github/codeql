/**
 * @name Uncontrolled data in arithmetic expression
 * @description Arithmetic operations on uncontrolled data that is not
 *              validated can cause overflows.
 * @kind problem
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

predicate isRandValue(Expr e) {
  e.(FunctionCall).getTarget().getName() = "rand"
  or
  exists(MacroInvocation mi |
    e = mi.getExpr() and
    e.getAChild*().(FunctionCall).getTarget().getName() = "rand"
  )
}

class SecurityOptionsArith extends SecurityOptions {
  override predicate isUserInput(Expr expr, string cause) {
    isRandValue(expr) and
    cause = "rand" and
    not expr.getParent*() instanceof DivExpr
  }
}

predicate taintedVarAccess(Expr origin, VariableAccess va) {
  isUserInput(origin, _) and
  tainted(origin, va)
}

/**
 * A value that undergoes division is likely to be bounded within a safe
 * range.
 */
predicate guardedByAssignDiv(Expr origin) {
  isUserInput(origin, _) and
  exists(AssignDivExpr div, VariableAccess va | tainted(origin, va) and div.getLValue() = va)
}

from Expr origin, Operation op, VariableAccess va, string effect
where
  taintedVarAccess(origin, va) and
  op.getAnOperand() = va and
  (
    missingGuardAgainstUnderflow(op, va) and effect = "underflow"
    or
    missingGuardAgainstOverflow(op, va) and effect = "overflow"
  ) and
  not guardedByAssignDiv(origin)
select va, "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  origin, "Uncontrolled value"
