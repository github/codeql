/**
 * @name Constant condition
 * @description A condition that always evaluates to 'true' or always evaluates to 'false'
 *              should be removed, and if the condition is a loop condition, the condition
 *              is likely to cause an infinite loop.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/constant-condition
 * @tags quality
 *       maintainability
 *       readability
 *       external/cwe/cwe-835
 */

import csharp
import semmle.code.csharp.commons.Assertions
import semmle.code.csharp.commons.Constants
import semmle.code.csharp.controlflow.BasicBlocks
import semmle.code.csharp.controlflow.Guards as Guards
import codeql.controlflow.queries.ConstantCondition as ConstCond

module ConstCondInput implements ConstCond::InputSig<ControlFlow::BasicBlock> {
  class SsaDefinition = Ssa::Definition;

  class GuardValue = Guards::GuardValue;

  class Guard = Guards::Guards::Guard;

  predicate ssaControlsBranchEdge(SsaDefinition def, BasicBlock bb1, BasicBlock bb2, GuardValue v) {
    Guards::Guards::ssaControlsBranchEdge(def, bb1, bb2, v)
  }

  predicate ssaControls(SsaDefinition def, BasicBlock bb, GuardValue v) {
    Guards::Guards::ssaControls(def, bb, v)
  }

  import Guards::Guards::InternalUtil
}

module ConstCondImpl = ConstCond::Make<Location, Cfg, ConstCondInput>;

predicate nullCheck(Expr e, boolean direct) {
  exists(QualifiableExpr qe | qe.isConditional() and qe.getQualifier() = e and direct = true)
  or
  exists(NullCoalescingExpr nce | nce.getLeftOperand() = e and direct = true)
  or
  exists(ConditionalExpr ce | ce.getThen() = e or ce.getElse() = e |
    nullCheck(ce, _) and direct = false
  )
}

predicate constantGuard(
  Guards::Guards::Guard g, string msg, Guards::Guards::Guard reason, string reasonMsg
) {
  ConstCondImpl::problems(g, msg, reason, reasonMsg) and
  // conditional qualified expressions sit at an akward place in the CFG, which
  // leads to FPs
  not g.(QualifiableExpr).getQualifier() = reason and
  // and if they're extension method calls, the syntactic qualifier is actually argument 0
  not g.(ExtensionMethodCall).getArgument(0) = reason and
  // if a logical connective is constant, one of its operands is constant, so
  // we report that instead
  not g instanceof LogicalNotExpr and
  not g instanceof LogicalAndExpr and
  not g instanceof LogicalOrExpr and
  // if a logical connective is a reason for another condition to be constant,
  // then one of its operands is a more precise reason
  not reason instanceof LogicalNotExpr and
  not reason instanceof LogicalAndExpr and
  not reason instanceof LogicalOrExpr and
  // don't report double-checked locking
  not exists(LockStmt ls, BasicBlock bb |
    bb = ls.getBasicBlock() and
    reason.getBasicBlock().strictlyDominates(bb) and
    bb.dominates(g.getBasicBlock())
  ) and
  // exclude indirect null checks like `x` in `(b ? x : null)?.Foo()`
  not nullCheck(g, false)
}

/** A constant condition. */
abstract class ConstantCondition extends Guards::Guards::Guard {
  /** Gets the alert message for this constant condition. */
  abstract string getMessage();

  predicate hasReason(Guards::Guards::Guard reason, string reasonMsg) {
    // dummy value, overridden when message has a placeholder
    reason = this and reasonMsg = "dummy"
  }

  /** Holds if this constant condition is white-listed. */
  predicate isWhiteListed() { none() }
}

/** A constant guard. */
class ConstantGuard extends ConstantCondition {
  ConstantGuard() { constantGuard(this, _, _, _) }

  override string getMessage() { constantGuard(this, result, _, _) }

  override predicate hasReason(Guards::Guards::Guard reason, string reasonMsg) {
    constantGuard(this, _, reason, reasonMsg)
  }
}

/** A constant Boolean condition. */
class ConstantBooleanCondition extends ConstantCondition {
  boolean b;

  ConstantBooleanCondition() { isConstantCondition(this, b) }

  override string getMessage() { result = "Condition always evaluates to '" + b + "'." }

  override predicate isWhiteListed() {
    // E.g. `x ?? false`
    this.(BoolLiteral) = any(NullCoalescingExpr nce).getRightOperand() or
    // No need to flag logical operations when the operands are constant
    isConstantCondition(this.(LogicalNotExpr).getOperand(), _) or
    this =
      any(LogicalAndExpr lae |
        isConstantCondition(lae.getAnOperand(), false)
        or
        isConstantCondition(lae.getLeftOperand(), true) and
        isConstantCondition(lae.getRightOperand(), true)
      ) or
    this =
      any(LogicalOrExpr loe |
        isConstantCondition(loe.getAnOperand(), true)
        or
        isConstantCondition(loe.getLeftOperand(), false) and
        isConstantCondition(loe.getRightOperand(), false)
      )
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
    this instanceof AssignableRead and
    not this instanceof ParameterRead
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
      exists(ControlFlow::NullnessSuccessor t, ControlFlow::Node s |
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
    this instanceof Expr and
    forex(ControlFlow::Node cfn | cfn = this.getAControlFlowNode() |
      exists(ControlFlow::MatchingSuccessor t | exists(cfn.getASuccessorByType(t)) |
        b = t.getValue()
      ) and
      strictcount(ControlFlow::SuccessorType t | exists(cfn.getASuccessorByType(t))) = 1
    )
  }

  override predicate isWhiteListed() {
    exists(Switch se, Case c, int i |
      c = se.getCase(i) and
      c.getPattern() = this.(DiscardExpr)
    |
      i > 0
      or
      i = 0 and
      exists(Expr cond | c.getCondition() = cond and not isConstantCondition(cond, true))
    )
    or
    this = any(PositionalPatternExpr ppe).getPattern(_)
  }

  override string getMessage() {
    if b = true then result = "Pattern always matches." else result = "Pattern never matches."
  }
}

from ConstantCondition c, string msg, Guards::Guards::Guard reason, string reasonMsg
where
  msg = c.getMessage() and
  c.hasReason(reason, reasonMsg) and
  not c.isWhiteListed() and
  not isExprInAssertion(c)
select c, msg, reason, reasonMsg
