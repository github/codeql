/**
 * @name Constant condition
 * @description A condition that always evaluates to 'true' or always evaluates to 'false'
 *              should be removed, and if the condition is a loop condition, the condition
 *              is likely to cause an infinite loop.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/constant-condition
 * @tags maintainability
 *       readability
 *       external/cwe/cwe-835
 */
import csharp
import semmle.code.csharp.commons.Assertions
import semmle.code.csharp.commons.Constants

/** A condition of an `if` statement or a conditional expression. */
private class IfCondition extends Expr {
  IfCondition() {
    this = any(IfStmt is).getCondition() or
    this = any(ConditionalExpr ce).getCondition()
  }
}

/** A loop condition */
private class LoopCondition extends Expr {
  LoopCondition() {
    this = any(LoopStmt ls).getCondition()
  }
}

/** Holds if `e` is a conditional expression that is allowed to be constant. */
predicate isWhiteListed(Expr e) {
  // It is a common pattern to use a local constant/constant field to control
  // whether code parts must be executed or not
  e = any(IfCondition ic).getAChildExpr*() and
  e instanceof AssignableRead
  or
  // Clearly intentional infinite loops are allowed
  e instanceof LoopCondition and
  e.(BoolLiteral).getBoolValue() = true
  or
  // E.g. `x ?? false`
  e.(BoolLiteral) = any(NullCoalescingExpr nce).getRightOperand()
}

from Expr e, boolean b
where isConstantCondition(e, b)
  and not isWhiteListed(e)
  and not isExprInAssertion(e)
select e, "Condition always evaluates to '" + b + "'."
