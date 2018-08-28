/**
 * @name Use of extreme values in arithmetic expression
 * @description If a variable is assigned the maximum or minimum value
 *              for that variable's type and is then used in an
 *              arithmetic expression, this may result in an overflow.
 * @kind problem
 * @id cpp/arithmetic-with-extreme-values
 * @problem.severity warning
 * @precision low
 * @tags security
 *       reliability
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */
import cpp

import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking

predicate isMaxValue(MacroInvocationExpr mie) {
  mie.getMacroName() = "CHAR_MAX" or
  mie.getMacroName() = "LLONG_MAX" or
  mie.getMacroName() = "INT_MAX" or
  mie.getMacroName() = "SHRT_MAX" or
  mie.getMacroName() = "UINT_MAX"
}

predicate isMinValue(MacroInvocationExpr mie) {
  mie.getMacroName() = "CHAR_MIN" or
  mie.getMacroName() = "LLONG_MIN" or
  mie.getMacroName() = "INT_MIN" or
  mie.getMacroName() = "SHRT_MIN"
}

class SecurityOptionsArith extends SecurityOptions {
  override predicate isUserInput(Expr expr, string cause) {
    (isMaxValue(expr) and cause = "max value") or
    (isMinValue(expr) and cause = "min value")
  }
}

predicate taintedVarAccess(Expr origin, VariableAccess va, string cause) {
  isUserInput(origin, cause) and
  tainted(origin, va)
}

predicate causeEffectCorrespond(string cause, string effect) {
  (
    cause = "max value" and
    effect = "overflow"
  ) or (
    cause = "min value" and
    effect = "underflow"
  )
}

from Expr origin, Operation op, VariableAccess va, string cause, string effect
where taintedVarAccess(origin, va, cause)
  and op.getAnOperand() = va
  and
  (
    (missingGuardAgainstUnderflow(op, va) and effect = "underflow") or
    (missingGuardAgainstOverflow(op, va) and effect = "overflow")
  ) and
  causeEffectCorrespond(cause, effect)
select va, "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  origin, "Extreme value"
