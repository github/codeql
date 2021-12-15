/**
 * @name Dangerous non-short-circuit logic
 * @description Using a bitwise logical operator on a boolean where a conditional-and or
 *              conditional-or operator is intended may yield the wrong result or
 *              cause an exception.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/non-short-circuit-evaluation
 * @tags reliability
 *       readability
 *       external/cwe/cwe-691
 */

import java

/** An expression containing a method access, array access, or qualified field access. */
class DangerousExpression extends Expr {
  DangerousExpression() {
    exists(Expr e | this = e.getParent*() |
      e instanceof MethodAccess or
      e instanceof ArrayAccess or
      exists(e.(FieldAccess).getQualifier())
    )
  }
}

/** A use of `&` or `|` on operands of type boolean. */
class NonShortCircuit extends BinaryExpr {
  NonShortCircuit() {
    (
      this instanceof AndBitwiseExpr or
      this instanceof OrBitwiseExpr
    ) and
    this.getLeftOperand().getType().hasName("boolean") and
    this.getRightOperand().getType().hasName("boolean") and
    this.getRightOperand() instanceof DangerousExpression
  }
}

from NonShortCircuit e
select e, "Possibly dangerous use of non-short circuit logic."
