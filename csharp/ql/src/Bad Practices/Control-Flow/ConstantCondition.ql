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
import semmle.code.csharp.controlflow.Guards as Guards
import codeql.controlflow.queries.ConstantCondition as ConstCond

module ConstCondInput implements ConstCond::InputSig<BasicBlock> {
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
  exists(QualifiableExpr qe | qe.isConditional() and direct = true |
    qe.getQualifier() = e or qe.(ExtensionMethodCall).getArgument(0) = e
  )
  or
  exists(NullCoalescingOperation nce | nce.getLeftOperand() = e and direct = true)
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

  ConstantBooleanCondition() { isConstantComparison(this, b) }

  override string getMessage() { result = "Condition always evaluates to '" + b + "'." }
}

private Expr getQualifier(QualifiableExpr e) {
  // `e.getQualifier()` does not work for calls to extension methods
  result = e.getChildExpr(-1)
}

/** A constant nullness condition. */
class ConstantNullnessCondition extends ConstantCondition {
  boolean b;

  ConstantNullnessCondition() {
    nullCheck(this, true) and
    exists(Expr stripped | stripped = this.(Expr).stripCasts() |
      stripped.getType() =
        any(ValueType t |
          not t instanceof NullableType and
          // Extractor bug: the type of `x?.Length` is reported as `int`, but it should
          // be `int?`
          not getQualifier*(stripped).(QualifiableExpr).isConditional()
        ) and
      b = false
      or
      stripped instanceof NullLiteral and
      b = true
      or
      stripped.hasValue() and
      not stripped instanceof NullLiteral and
      b = false
    )
  }

  override string getMessage() {
    if b = true
    then result = "Expression is always 'null'."
    else result = "Expression is never 'null'."
  }
}

from ConstantCondition c, string msg, Guards::Guards::Guard reason, string reasonMsg
where
  msg = c.getMessage() and
  c.hasReason(reason, reasonMsg) and
  not c.isWhiteListed() and
  not isExprInAssertion(c)
select c, msg, reason, reasonMsg
