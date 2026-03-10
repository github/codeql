/**
 * @name Potentially dangerous use of non-short-circuit logic
 * @description The & and | operators do not use short-circuit evaluation and can be dangerous when applied to boolean operands. In particular, their
 *              use can result in errors if the left-hand operand checks for cases in which it is not safe to evaluate the right-hand one.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/non-short-circuit
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-691
 */

import csharp

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
    this.getRightOperand().getType() instanceof BoolType
  }

  pragma[nomagic]
  private predicate hasRightOperandDescendant(Expr e) {
    e = this.getRightOperand()
    or
    exists(Expr parent |
      this.hasRightOperandDescendant(parent) and
      e.getParent() = parent
    )
  }

  /**
   * Holds if this non-short-circuit expression contains a qualified member access,
   * a method call, or an array access inside the right operand.
   */
  predicate isDangerous() {
    exists(Expr e | this.hasRightOperandDescendant(e) |
      exists(Expr q | q = e.(MemberAccess).getQualifier() |
        not q instanceof ThisAccess and
        not q instanceof BaseAccess
      )
      or
      e instanceof MethodCall
      or
      e instanceof ArrayAccess
    ) and
    not exists(Expr e | this.hasRightOperandDescendant(e) |
      e.(Call).getTarget().getAParameter().isOutOrRef()
    )
  }
}

from NonShortCircuit e
where e.isDangerous()
select e, "Potentially dangerous use of non-short circuit logic."
