/**
 * @name User-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is
 *              not validated can cause overflows.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/tainted-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */
import cpp

import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking

predicate taintedVarAccess(Expr origin, VariableAccess va) {
  isUserInput(origin, _) and
  tainted(origin, va)
}

from Expr origin, Operation op, VariableAccess va, string effect
where taintedVarAccess(origin, va)
  and op.getAnOperand() = va
  and
  (
    (missingGuardAgainstUnderflow(op, va) and effect = "underflow") or
    (missingGuardAgainstOverflow(op, va) and effect = "overflow")
  )
select va, "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  origin, "User-provided value"
