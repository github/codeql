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

/** A constant condition. */
abstract class ConstantCondition extends Expr {
  /** Gets the alert message for this constant condition. */
  abstract string getMessage();

  /** Holds if this constant condition is white-listed. */
  predicate isWhiteListed() { none() }
}

/** A constant Boolean condition. */
class ConstantBooleanCondition extends ConstantCondition {
  boolean b;

  ConstantBooleanCondition() { isConstantCondition(this, b) }

  override string getMessage() { result = "Condition always evaluates to '" + b + "'." }

  override predicate isWhiteListed() {
    // E.g. `x ?? false`
    this.(BoolLiteral) = any(NullCoalescingExpr nce).getRightOperand()
  }
}

/** A constant condition in an `if` statement or a conditional expression. */
class ConstantIfCondition extends ConstantBooleanCondition {
  ConstantIfCondition() {
    this = any(IfStmt is).getCondition().getAChildExpr*() or
    this = any(ConditionalExpr ce).getCondition().getAChildExpr*()
  }

  override predicate isWhiteListed() {
    ConstantBooleanCondition.super.isWhiteListed()
    or
    // It is a common pattern to use a local constant/constant field to control
    // whether code parts must be executed or not
    this instanceof AssignableRead
  }
}

/** A constant loop condition. */
class ConstantLoopCondition extends ConstantBooleanCondition {
  ConstantLoopCondition() { this = any(LoopStmt ls).getCondition() }

  override predicate isWhiteListed() {
    // Clearly intentional infinite loops are allowed
    this.(BoolLiteral).getBoolValue() = true
  }
}

/** A constant nullness condition. */
class ConstantNullnessCondition extends ConstantCondition {
  boolean b;

  ConstantNullnessCondition() {
    forex(ControlFlow::Node cfn | cfn = this.getAControlFlowNode() |
      exists(ControlFlow::SuccessorTypes::NullnessSuccessor t, ControlFlow::Node s |
        s = cfn.getASuccessorByType(t)
      |
        b = t.getValue() and
        not s.isJoin()
      ) and
      strictcount(ControlFlow::SuccessorType t | exists(cfn.getASuccessorByType(t))) = 1
    )
  }

  override string getMessage() {
    if b = true
    then result = "Expression is always 'null'."
    else result = "Expression is never 'null'."
  }
}

/** A constant matching condition. */
class ConstantMatchingCondition extends ConstantCondition {
  boolean b;

  ConstantMatchingCondition() {
    forex(ControlFlow::Node cfn | cfn = this.getAControlFlowNode() |
      exists(ControlFlow::SuccessorTypes::MatchingSuccessor t | exists(cfn.getASuccessorByType(t)) |
        b = t.getValue()
      ) and
      strictcount(ControlFlow::SuccessorType t | exists(cfn.getASuccessorByType(t))) = 1
    )
  }

  override predicate isWhiteListed() {
    exists(SwitchExpr se |
      se.getACase().getPattern() = this.(DiscardExpr) and
      strictcount(se.getACase()) > 1
    )
  }

  override string getMessage() {
    if b = true then result = "Pattern always matches." else result = "Pattern never matches."
  }
}

from ConstantCondition c, string msg
where
  msg = c.getMessage() and
  not c.isWhiteListed() and
  not isExprInAssertion(c)
select c, msg
