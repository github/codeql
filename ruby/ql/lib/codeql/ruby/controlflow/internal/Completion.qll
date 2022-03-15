/**
 * Provides classes representing control flow completions.
 *
 * A completion represents how a statement or expression terminates.
 */

private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST
private import codeql.ruby.ast.internal.Control
private import codeql.ruby.controlflow.ControlFlowGraph
private import ControlFlowGraphImpl
private import NonReturning
private import SuccessorTypes

private newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(boolean b) { b in [false, true] } or
  TMatchingCompletion(boolean isMatch) { isMatch in [false, true] } or
  TReturnCompletion() or
  TBreakCompletion() or
  TNextCompletion() or
  TRedoCompletion() or
  TRetryCompletion() or
  TRaiseCompletion() or // TODO: Add exception type?
  TExitCompletion() or
  TNestedCompletion(TCompletion inner, TCompletion outer, int nestLevel) {
    inner = TBreakCompletion() and
    outer instanceof NonNestedNormalCompletion and
    nestLevel = 0
    or
    inner instanceof TBooleanCompletion and
    outer instanceof TMatchingCompletion and
    nestLevel = 0
    or
    inner instanceof NormalCompletion and
    nestedEnsureCompletion(outer, nestLevel)
  }

pragma[noinline]
private predicate nestedEnsureCompletion(TCompletion outer, int nestLevel) {
  (
    outer = TReturnCompletion()
    or
    outer = TBreakCompletion()
    or
    outer = TNextCompletion()
    or
    outer = TRedoCompletion()
    or
    outer = TRetryCompletion()
    or
    outer = TRaiseCompletion()
    or
    outer = TExitCompletion()
  ) and
  nestLevel = any(Trees::BodyStmtTree t).getNestLevel()
}

pragma[noinline]
private predicate completionIsValidForStmt(AstNode n, Completion c) {
  n instanceof BreakStmt and
  c = TBreakCompletion()
  or
  n instanceof NextStmt and
  c = TNextCompletion()
  or
  n instanceof RedoStmt and
  c = TRedoCompletion()
  or
  n instanceof ReturnStmt and
  c = TReturnCompletion()
}

/**
 * Holds if `c` happens in an exception-aware context, that is, it may be
 * `rescue`d or `ensure`d. In such cases, we assume that the target of `c`
 * may raise an exception (in addition to evaluating normally).
 */
private predicate mayRaise(Call c) {
  exists(Trees::BodyStmtTree bst | c = bst.getBodyChild(_, true).getAChild*() |
    exists(bst.getARescue())
    or
    exists(bst.getEnsure())
  )
}

/** A completion of a statement or an expression. */
abstract class Completion extends TCompletion {
  private predicate isValidForSpecific(AstNode n) {
    exists(AstNode other | n = other.getDesugared() and this.isValidForSpecific(other))
    or
    this = n.(NonReturningCall).getACompletion()
    or
    completionIsValidForStmt(n, this)
    or
    mustHaveBooleanCompletion(n) and
    (
      exists(boolean value | isBooleanConstant(n, value) | this = TBooleanCompletion(value))
      or
      not isBooleanConstant(n, _) and
      this = TBooleanCompletion(_)
    )
    or
    mustHaveMatchingCompletion(n) and
    this = TMatchingCompletion(_)
    or
    n = any(RescueModifierExpr parent).getBody() and
    this = [TSimpleCompletion().(TCompletion), TRaiseCompletion()]
    or
    mayRaise(n) and
    (
      this = TRaiseCompletion()
      or
      this = TSimpleCompletion() and not n instanceof NonReturningCall
    )
  }

  /** Holds if this completion is valid for node `n`. */
  predicate isValidFor(AstNode n) {
    this.isValidForSpecific(n)
    or
    not any(Completion c).isValidForSpecific(n) and
    this = TSimpleCompletion()
  }

  /**
   * Holds if this completion will continue a loop when it is the completion
   * of a loop body.
   */
  predicate continuesLoop() {
    this instanceof NormalCompletion or
    this instanceof NextCompletion
  }

  /**
   * Gets the inner completion. This is either the inner completion,
   * when the completion is nested, or the completion itself.
   */
  Completion getInnerCompletion() { result = this }

  /**
   * Gets the outer completion. This is either the outer completion,
   * when the completion is nested, or the completion itself.
   */
  Completion getOuterCompletion() { result = this }

  /** Gets a successor type that matches this completion. */
  abstract SuccessorType getAMatchingSuccessorType();

  /** Gets a textual representation of this completion. */
  abstract string toString();
}

/** Holds if node `n` has the Boolean constant value `value`. */
private predicate isBooleanConstant(AstNode n, boolean value) {
  mustHaveBooleanCompletion(n) and
  (
    n.(BooleanLiteral).isTrue() and
    value = true
    or
    n.(BooleanLiteral).isFalse() and
    value = false
  )
}

/**
 * Holds if a normal completion of `n` must be a Boolean completion.
 */
private predicate mustHaveBooleanCompletion(AstNode n) {
  inBooleanContext(n) and
  not n instanceof NonReturningCall
}

/**
 * Holds if `n` is used in a Boolean context. That is, the value
 * that `n` evaluates to determines a true/false branch successor.
 */
private predicate inBooleanContext(AstNode n) {
  exists(ConditionalExpr i |
    n = i.getCondition()
    or
    inBooleanContext(i) and
    n = i.getBranch(_)
  )
  or
  n = any(ConditionalLoop parent).getCondition()
  or
  n = any(InClause parent).getCondition()
  or
  exists(LogicalAndExpr parent |
    n = parent.getLeftOperand()
    or
    inBooleanContext(parent) and
    n = parent.getRightOperand()
  )
  or
  exists(LogicalOrExpr parent |
    n = parent.getLeftOperand()
    or
    inBooleanContext(parent) and
    n = parent.getRightOperand()
  )
  or
  n = any(NotExpr parent | inBooleanContext(parent)).getOperand()
  or
  n = any(StmtSequence parent | inBooleanContext(parent)).getLastStmt()
  or
  exists(CaseExpr c, WhenClause w |
    not exists(c.getValue()) and
    c.getABranch() = w and
    w.getPattern(_) = n
  )
}

/**
 * Holds if a normal completion of `n` must be a matching completion.
 */
private predicate mustHaveMatchingCompletion(AstNode n) {
  inMatchingContext(n) and
  not n instanceof NonReturningCall
}

/**
 * Holds if `n` is used in a matching context. That is, whether or
 * not the value of `n` matches, determines the successor.
 */
private predicate inMatchingContext(AstNode n) {
  n = any(RescueClause r).getException(_)
  or
  exists(CaseExpr c, WhenClause w |
    exists(c.getValue()) and
    c.getABranch() = w and
    w.getPattern(_) = n
  )
  or
  n instanceof CasePattern
  or
  n = any(ReferencePattern p).getExpr()
  or
  n.(Trees::DefaultValueParameterTree).hasDefaultValue()
}

/**
 * A completion that represents normal evaluation of a statement or an
 * expression.
 */
abstract class NormalCompletion extends Completion { }

abstract private class NonNestedNormalCompletion extends NormalCompletion { }

/** A simple (normal) completion. */
class SimpleCompletion extends NonNestedNormalCompletion, TSimpleCompletion {
  override NormalSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "simple" }
}

/**
 * A completion that represents evaluation of an expression, whose value determines
 * the successor. Either a Boolean completion (`BooleanCompletion`), or a matching
 * completion (`MatchingCompletion`).
 */
abstract class ConditionalCompletion extends NormalCompletion {
  boolean value;

  bindingset[value]
  ConditionalCompletion() { any() }

  /** Gets the Boolean value of this conditional completion. */
  final boolean getValue() { result = value }
}

/**
 * A completion that represents evaluation of an expression
 * with a Boolean value.
 */
class BooleanCompletion extends ConditionalCompletion, NonNestedNormalCompletion, TBooleanCompletion {
  BooleanCompletion() { this = TBooleanCompletion(value) }

  /** Gets the dual Boolean completion. */
  BooleanCompletion getDual() { result = TBooleanCompletion(value.booleanNot()) }

  override BooleanSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  override string toString() { result = value.toString() }
}

/** A Boolean `true` completion. */
class TrueCompletion extends BooleanCompletion {
  TrueCompletion() { this.getValue() = true }
}

/** A Boolean `false` completion. */
class FalseCompletion extends BooleanCompletion {
  FalseCompletion() { this.getValue() = false }
}

/**
 * A completion that represents evaluation of a matching test, for example
 * a test in a `rescue` statement.
 */
class MatchingCompletion extends ConditionalCompletion {
  MatchingCompletion() {
    this = TMatchingCompletion(value)
    or
    this = TNestedCompletion(_, TMatchingCompletion(value), _)
  }

  override ConditionalSuccessor getAMatchingSuccessorType() {
    this = TMatchingCompletion(result.(MatchingSuccessor).getValue())
  }

  override string toString() { if value = true then result = "match" else result = "no-match" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a return.
 */
class ReturnCompletion extends Completion {
  ReturnCompletion() {
    this = TReturnCompletion() or
    this = TNestedCompletion(_, TReturnCompletion(), _)
  }

  override ReturnSuccessor getAMatchingSuccessorType() { any() }

  override string toString() {
    // `NestedCompletion` defines `toString()` for the other case
    this = TReturnCompletion() and result = "return"
  }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a break from a loop.
 */
class BreakCompletion extends Completion {
  BreakCompletion() {
    this = TBreakCompletion() or
    this = TNestedCompletion(_, TBreakCompletion(), _)
  }

  override BreakSuccessor getAMatchingSuccessorType() { any() }

  override string toString() {
    // `NestedCompletion` defines `toString()` for the other case
    this = TBreakCompletion() and result = "break"
  }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a continuation of a loop.
 */
class NextCompletion extends Completion {
  NextCompletion() {
    this = TNextCompletion() or
    this = TNestedCompletion(_, TNextCompletion(), _)
  }

  override NextSuccessor getAMatchingSuccessorType() { any() }

  override string toString() {
    // `NestedCompletion` defines `toString()` for the other case
    this = TNextCompletion() and result = "next"
  }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a redo of a loop iteration.
 */
class RedoCompletion extends Completion {
  RedoCompletion() {
    this = TRedoCompletion() or
    this = TNestedCompletion(_, TRedoCompletion(), _)
  }

  override RedoSuccessor getAMatchingSuccessorType() { any() }

  override string toString() {
    // `NestedCompletion` defines `toString()` for the other case
    this = TRedoCompletion() and result = "redo"
  }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a retry.
 */
class RetryCompletion extends Completion {
  RetryCompletion() {
    this = TRetryCompletion() or
    this = TNestedCompletion(_, TRetryCompletion(), _)
  }

  override RetrySuccessor getAMatchingSuccessorType() { any() }

  override string toString() {
    // `NestedCompletion` defines `toString()` for the other case
    this = TRetryCompletion() and result = "retry"
  }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a thrown exception.
 */
class RaiseCompletion extends Completion {
  RaiseCompletion() {
    this = TRaiseCompletion() or
    this = TNestedCompletion(_, TRaiseCompletion(), _)
  }

  override RaiseSuccessor getAMatchingSuccessorType() { any() }

  override string toString() {
    // `NestedCompletion` defines `toString()` for the other case
    this = TRaiseCompletion() and result = "raise"
  }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in an abort/exit.
 */
class ExitCompletion extends Completion {
  ExitCompletion() {
    this = TExitCompletion() or
    this = TNestedCompletion(_, TExitCompletion(), _)
  }

  override ExitSuccessor getAMatchingSuccessorType() { any() }

  override string toString() {
    // `NestedCompletion` defines `toString()` for the other case
    this = TExitCompletion() and result = "exit"
  }
}

/**
 * A nested completion. For example, in
 *
 * ```rb
 * def m
 *   while x >= 0
 *     x -= 1
 *     if num > 100
 *       break
 *     end
 *   end
 *   puts "done"
 * end
 * ```
 *
 * the `while` loop can have a nested completion where the inner completion
 * is a `break` and the outer completion is a simple successor.
 */
abstract class NestedCompletion extends Completion, TNestedCompletion {
  Completion inner;
  Completion outer;
  int nestLevel;

  NestedCompletion() { this = TNestedCompletion(inner, outer, nestLevel) }

  /** Gets a completion that is compatible with the inner completion. */
  Completion getAnInnerCompatibleCompletion() {
    result.getOuterCompletion() = this.getInnerCompletion()
  }

  /** Gets the level of this nested completion. */
  final int getNestLevel() { result = nestLevel }

  override string toString() { result = outer + " [" + inner + "] (" + nestLevel + ")" }
}

class NestedBreakCompletion extends NormalCompletion, NestedCompletion {
  NestedBreakCompletion() {
    inner = TBreakCompletion() and
    outer instanceof NonNestedNormalCompletion
  }

  override BreakCompletion getInnerCompletion() { result = inner }

  override NonNestedNormalCompletion getOuterCompletion() { result = outer }

  override Completion getAnInnerCompatibleCompletion() {
    result = inner and
    outer = TSimpleCompletion()
    or
    result = TNestedCompletion(outer, inner, _)
  }

  override SuccessorType getAMatchingSuccessorType() {
    outer instanceof SimpleCompletion and
    result instanceof BreakSuccessor
    or
    result = outer.(ConditionalCompletion).getAMatchingSuccessorType()
  }
}

class NestedEnsureCompletion extends NestedCompletion {
  NestedEnsureCompletion() {
    inner instanceof NormalCompletion and
    nestedEnsureCompletion(outer, nestLevel)
  }

  override NormalCompletion getInnerCompletion() { result = inner }

  override Completion getOuterCompletion() { result = outer }

  override SuccessorType getAMatchingSuccessorType() { none() }
}

/**
 * A completion used for conditions in pattern matching:
 *
 * ```rb
 * in x if x == 5 then puts "five"
 * in x unless x == 4 then puts "not four"
 * ```
 *
 * The outer (Matching) completion indicates whether there is a match, and
 * the inner (Boolean) completion indicates what the condition evaluated
 * to.
 *
 * For the condition `x == 5` above, `TNestedCompletion(true, true, 0)` and
 * `TNestedCompletion(false, false, 0)` are both valid completions, while
 * `TNestedCompletion(true, false, 0)` and `TNestedCompletion(false, true, 0)`
 * are valid completions for `x == 4`.
 */
class NestedMatchingCompletion extends NestedCompletion, MatchingCompletion {
  NestedMatchingCompletion() {
    inner instanceof TBooleanCompletion and
    outer instanceof TMatchingCompletion
  }

  override BooleanCompletion getInnerCompletion() { result = inner }

  override MatchingCompletion getOuterCompletion() { result = outer }

  override BooleanSuccessor getAMatchingSuccessorType() {
    result.getValue() = this.getInnerCompletion().getValue()
  }

  override string toString() { result = NestedCompletion.super.toString() }
}
