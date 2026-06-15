/**
 * @name Bad parity check
 * @description Code that uses 'x % 2 == 1' or 'x % 2 > 0' to check whether a number is odd does not
 *              work for negative numbers.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/incomplete-parity-check
 * @tags reliability
 *       correctness
 */

import csharp

predicate isDefinitelyPositive(Expr e) {
  e.getIntValue() >= 0 or
  e.(PropertyAccess).getTarget().hasName("Length") or
  e.(MethodCall).getTarget().hasUndecoratedName("Count")
}

from BinaryOperation t, RemExpr lhs, IntegerLiteral rhs, string parity
where
  t.getLeftOperand() = lhs and
  t.getRightOperand() = rhs and
  not isDefinitelyPositive(lhs.getLeftOperand().stripCasts()) and
  lhs.getRightOperand().(IntegerLiteral).getIntValue() = 2 and
  (
    t instanceof EQExpr and rhs.getIntValue() = 1 and parity = "oddness"
    or
    t instanceof NEExpr and rhs.getIntValue() = 1 and parity = "evenness"
    or
    t instanceof GTExpr and rhs.getIntValue() = 0 and parity = "oddness"
  )
select t, "Possibly invalid test for " + parity + ". This will fail for negative numbers."
