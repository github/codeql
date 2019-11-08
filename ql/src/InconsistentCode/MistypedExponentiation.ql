/**
 * @name Bitwise exclusive-or used like exponentiation
 * @description Using ^ as exponentiation is a mistake, as it is the bitwise exclusive-or operator.
 * @kind problem
 * @problem.severity warning
 * @id go/mistyped-exponentiation
 * @precision high
 */

import go

/** Holds if `e` is not 0 and is either an octal or hexadecimal literal, or the number one. */
predicate maybeXorBitPattern(Expr e) {
  // 0 makes no sense as an xor bit pattern
  not e.getNumericValue() = 0 and
  // include octal and hex literals
  e.(IntLit).getText().matches("0%")
  or
  e.getNumericValue() = 1
}

from XorExpr xe, Expr lhs, Expr rhs
where
  lhs = xe.getLeftOperand() and
  rhs = xe.getRightOperand() and
  exists(lhs.getNumericValue()) and
  not maybeXorBitPattern(lhs) and
  (
    not maybeXorBitPattern(rhs) and
    rhs.getIntValue() >= 0
    or
    exists(Ident id | id = xe.getRightOperand() |
      id.getName().regexpMatch("(?i)_*((exp(onent)?)|pow(er)?)")
    )
  )
select xe,
  "This expression uses the bitwise exclusive-or operator when exponentiation was likely meant."
