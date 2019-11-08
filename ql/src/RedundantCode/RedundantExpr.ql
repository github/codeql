/**
 * @name Identical operands
 * @description Passing identical operands to an operator such as subtraction or conjunction may indicate a typo;
 *              even if it is intentional, it makes the code hard to read.
 * @kind problem
 * @problem.severity warning
 * @id go/redundant-operation
 * @tags correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision very-high
 */

import go

/**
 * Holds if `e` is a binary expression that is redundant if both operands are the same.
 */
predicate potentiallyRedundant(BinaryExpr e) {
  e instanceof SubExpr
  or
  e instanceof DivExpr
  or
  e instanceof ModExpr
  or
  e instanceof XorExpr
  or
  e instanceof AndNotExpr
  or
  e instanceof LogicalBinaryExpr
  or
  e instanceof BitAndExpr
  or
  e instanceof BitOrExpr
  or
  // an expression of the form `(e + f)/2`
  exists(DivExpr div |
    e.(AddExpr) = div.getLeftOperand().stripParens() and
    div.getRightOperand().getNumericValue() = 2
  )
}

/** Gets the global value number of `e`, which is the `i`th operand of `red`. */
GVN redundantOperandGVN(BinaryExpr red, int i, Expr e) {
  potentiallyRedundant(red) and
  (
    i = 0 and e = red.getLeftOperand()
    or
    i = 1 and e = red.getRightOperand()
  ) and
  result = e.getGlobalValueNumber()
}

from BinaryExpr red, Expr e, Expr f
where
  redundantOperandGVN(red, 0, e) = redundantOperandGVN(red, 1, f) and
  // whitelist trivial cases
  not (e instanceof BasicLit and f instanceof BasicLit) and
  // whitelist operations involving a symbolic constants and a literal constant; these are often feature flags
  not exists(DeclaredConstant decl |
    red.getAnOperand() = decl.getAReference() and
    red.getAnOperand() instanceof BasicLit
  )
select red, "The $@ and $@ operand of this operation are identical.", e, "left", f, "right"
