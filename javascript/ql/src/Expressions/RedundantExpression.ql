/**
 * @name Identical operands
 * @description Passing identical, or seemingly identical, operands to an
 *              operator such as subtraction or conjunction may indicate a typo;
 *              even if it is intentional, it makes the code hard to read.
 * @kind problem
 * @problem.severity warning
 * @id js/redundant-operation
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision very-high
 */

import Clones

/**
 * A clone detector that finds redundant expressions.
 */
abstract class RedundantOperand extends StructurallyCompared {
  RedundantOperand() { exists(BinaryExpr parent | this = parent.getLeftOperand()) }

  override Expr candidate() { result = getParent().(BinaryExpr).getRightOperand() }

  /** Gets the expression to report when a pair of clones is found. */
  Expr toReport() { result = getParent() }
}

/**
 * A binary expression whose operator is idemnecant.
 *
 * An idemnecant operator is an operator that yields a trivial result when applied to
 * identical operands (disregarding overflow and special floating point values).
 *
 * For instance, subtraction is idemnecant (since `e-e=0`), and so is division (since `e/e=1`).
 */
class IdemnecantExpr extends BinaryExpr {
  IdemnecantExpr() {
    this instanceof SubExpr or
    this instanceof DivExpr or
    this instanceof ModExpr or
    this instanceof XOrExpr
  }
}

/**
 * A clone detector for idemnecant operators.
 */
class RedundantIdemnecantOperand extends RedundantOperand {
  RedundantIdemnecantOperand() {
    exists(IdemnecantExpr parent |
      parent = getParent() and
      // exclude trivial cases like `1-1`
      not parent.getRightOperand().getUnderlyingValue() instanceof Literal
    )
  }
}

/**
 * A clone detector for idempotent expressions.
 *
 * Note that `&` and `|` are not idempotent in JavaScript, since they coerce their
 * arguments to integers. For example, `x&x` is a common idiom for converting `x` to an integer.
 */
class RedundantIdempotentOperand extends RedundantOperand {
  RedundantIdempotentOperand() {
    getParent() instanceof LogicalBinaryExpr and
    not exists(UpdateExpr e | e.getParentExpr+() = this)
  }
}

/**
 * An expression of the form `(e + f)/2`.
 */
class AverageExpr extends DivExpr {
  AverageExpr() {
    getLeftOperand().getUnderlyingValue() instanceof AddExpr and
    getRightOperand().getIntValue() = 2
  }
}

/**
 * A clone detector for redundant expressions of the form `(e + e)/2`.
 */
class RedundantAverageOperand extends RedundantOperand {
  RedundantAverageOperand() {
    exists(AverageExpr aver | getParent().(AddExpr) = aver.getLeftOperand().getUnderlyingValue())
  }

  override AverageExpr toReport() { getParent() = result.getLeftOperand().getUnderlyingValue() }
}

from RedundantOperand e, Expr f
where e.same(f)
select e.toReport(), "Operands $@ and $@ are identical.", e, e.toString(), f, f.toString()
