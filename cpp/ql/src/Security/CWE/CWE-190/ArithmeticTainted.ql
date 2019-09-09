/**
 * @name User-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is
 *              not validated can cause overflows.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/tainted-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking

from Expr origin, Operation op, Expr e, string effect
where
  isUserInput(origin, _) and
  tainted(origin, e) and
  op.getAnOperand() = e and
  (
    missingGuardAgainstUnderflow(op, e) and effect = "underflow"
    or
    missingGuardAgainstOverflow(op, e) and effect = "overflow"
    or
    not e instanceof VariableAccess and effect = "overflow"
  ) and
  (
    op instanceof UnaryArithmeticOperation or
    op instanceof BinaryArithmeticOperation
  )
select e, "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".",
  origin, "User-provided value"
