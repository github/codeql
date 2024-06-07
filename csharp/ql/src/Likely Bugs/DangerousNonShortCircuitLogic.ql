/**
 * @name Potentially dangerous use of non-short-circuit logic
 * @description The & and | operators do not use short-circuit evaluation and can be dangerous when applied to boolean operands. In particular, their
 *              use can result in errors if the left-hand operand checks for cases in which it is not safe to evaluate the right-hand one.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/non-short-circuit
 * @tags reliability
 *       correctness
 *       logic
 *       external/cwe/cwe-480
 *       external/cwe/cwe-691
 */

import csharp

/** An expression containing a qualified member access, a method call, or an array access. */
class DangerousExpression extends Expr {
  DangerousExpression() {
    exists(Expr e | this = e.getParent*() |
      exists(Expr q | q = e.(MemberAccess).getQualifier() |
        not q instanceof ThisAccess and
        not q instanceof BaseAccess
      )
      or
      e instanceof MethodCall
      or
      e instanceof ArrayAccess
    ) and
    not exists(Expr e | this = e.getParent*() | e.(Call).getTarget().getAParameter().isOutOrRef())
  }
}

/** A use of `&` or `|` on operands of type boolean. */
class NonShortCircuit extends BinaryBitwiseOperation {
  NonShortCircuit() {
    (
      this instanceof BitwiseAndExpr
      or
      this instanceof BitwiseOrExpr
    ) and
    not exists(AssignBitwiseOperation abo | abo.getExpandedAssignment().getRValue() = this) and
    this.getLeftOperand().getType() instanceof BoolType and
    this.getRightOperand().getType() instanceof BoolType and
    this.getRightOperand() instanceof DangerousExpression
  }
}

from NonShortCircuit e
select e, "Potentially dangerous use of non-short circuit logic."
