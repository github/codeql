/**
 * @name Identical operands
 * @description Passing identical, or seemingly identical, operands to an
 *              operator such as subtraction or conjunction may indicate a typo;
 *              even if it is intentional, it makes the code hard to read.
 * @kind problem
 * @problem.severity warning
 * @id go/redundant-operation
 * @tags correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision very-high
 */

import Clones

/**
 * A binary expression that is redundant if both operands are the same.
 */
abstract class PotentiallyRedundantExpr extends BinaryExpr, HashRoot {
  predicate operands(Expr left, Expr right) {
    left = getLeftOperand() and right = getRightOperand()
  }
}

/**
 * A binary expression whose operator is idemnecant.
 *
 * An idemnecant operator is an operator that yields a trivial result when applied to
 * identical operands (disregarding overflow and special floating point values).
 *
 * For instance, subtraction is idemnecant (since `e-e=0`), and so is division (since `e/e=1`).
 */
class IdemnecantExpr extends PotentiallyRedundantExpr {
  IdemnecantExpr() {
    (
      this instanceof SubExpr or
      this instanceof DivExpr or
      this instanceof ModExpr or
      this instanceof XorExpr or
      this instanceof AndNotExpr
    ) and
    getLeftOperand().getKind() = getRightOperand().getKind() and
    // exclude trivial cases like `1-1`
    not getLeftOperand().stripParens() instanceof BasicLit
  }
}

/**
 * An idempotent expressions.
 */
class IdempotentExpr extends PotentiallyRedundantExpr {
  IdempotentExpr() {
    (
      this instanceof LogicalBinaryExpr or
      this instanceof BitAndExpr or
      this instanceof BitOrExpr
    ) and
    getLeftOperand().getKind() = getRightOperand().getKind()
  }
}

/**
 * An expression of the form `(e + f)/2`.
 */
class AverageExpr extends PotentiallyRedundantExpr, AddExpr {
  AverageExpr() {
    exists(DivExpr div |
      this = div.getLeftOperand().stripParens() and
      div.getRightOperand().getNumericValue() = 2 and
      getLeftOperand().getKind() = getRightOperand().getKind()
    )
  }

  override predicate operands(Expr left, Expr right) {
    left = getLeftOperand() and right = getRightOperand()
  }
}

/** Gets the hash of `nd`, which is the `i`th operand of `red`. */
HashedNode hashRedundantOperand(PotentiallyRedundantExpr red, int i, HashableNode nd) {
  exists(Expr left, Expr right | red.operands(left, right) |
    i = 0 and nd = left
    or
    i = 1 and nd = right
  ) and
  result = nd.hash()
}

from PotentiallyRedundantExpr red, Expr e, Expr f
where hashRedundantOperand(red, 0, e) = hashRedundantOperand(red, 1, f)
select red, "The $@ and $@ operand of this operation are identical.", e, "left", f, "right"
