/**
 * Provides classes representing control flow completions.
 *
 * A completion represents how a statement or expression terminates.
 */

private import codeql_ruby.ast.internal.TreeSitter::Generated
private import codeql_ruby.controlflow.ControlFlowGraph
private import AstNodes
private import NonReturning
private import SuccessorTypes

private newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(boolean b) { b = true or b = false } or
  TEmptinessCompletion(boolean isEmpty) { isEmpty = true or isEmpty = false } or
  TReturnCompletion() or
  TBreakCompletion() or
  TNextCompletion() or
  TRedoCompletion() or
  TRetryCompletion() or
  TRaiseCompletion() or // TODO: Add exception type?
  TExitCompletion() or
  TNestedCompletion(Completion inner, Completion outer) {
    outer = TSimpleCompletion() and
    inner = TBreakCompletion()
  }

pragma[noinline]
private predicate completionIsValidForStmt(AstNode n, Completion c) {
  n instanceof Break and
  c = TBreakCompletion()
  or
  n instanceof Next and
  c = TNextCompletion()
  or
  n instanceof Redo and
  c = TRedoCompletion()
  or
  n instanceof Return and
  c = TReturnCompletion()
}

/** A completion of a statement or an expression. */
abstract class Completion extends TCompletion {
  /** Holds if this completion is valid for node `n`. */
  predicate isValidFor(AstNode n) {
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
    not n instanceof NonReturningCall and
    not completionIsValidForStmt(n, _) and
    not mustHaveBooleanCompletion(n) and
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
    n.(Constant).getValue() = "true" and
    value = true
    or
    n.(Constant).getValue() = "false" and
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
  n = any(IfElsifAstNode parent).getConditionNode()
  or
  n = any(ConditionalLoopAstNode parent).getCondition()
  or
  exists(LogicalAndAstNode parent |
    n = parent.getLeft()
    or
    inBooleanContext(parent) and
    n = parent.getRight()
  )
  or
  exists(LogicalOrAstNode parent |
    n = parent.getLeft()
    or
    inBooleanContext(parent) and
    n = parent.getRight()
  )
  or
  n = any(LogicalNotAstNode parent | inBooleanContext(parent)).getOperand()
  or
  n = any(ParenthesizedStatement parent | inBooleanContext(parent)).getChild()
  or
  n instanceof Pattern
}

/**
 * A completion that represents normal evaluation of a statement or an
 * expression.
 */
abstract class NormalCompletion extends Completion { }

/** A simple (normal) completion. */
class SimpleCompletion extends NormalCompletion, TSimpleCompletion {
  override NormalSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "simple" }
}

/**
 * A completion that represents evaluation of an expression, whose value determines
 * the successor. Either a Boolean completion (`BooleanCompletion`)
 * or an emptiness completion (`EmptinessCompletion`).
 */
abstract class ConditionalCompletion extends NormalCompletion { }

/**
 * A completion that represents evaluation of an expression
 * with a Boolean value.
 */
class BooleanCompletion extends ConditionalCompletion, TBooleanCompletion {
  private boolean value;

  BooleanCompletion() { this = TBooleanCompletion(value) }

  /** Gets the Boolean value of this completion. */
  boolean getValue() { result = value }

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
 * A completion that represents evaluation of an emptiness test, for example
 * a test in a `for in` statement.
 */
class EmptinessCompletion extends ConditionalCompletion, TEmptinessCompletion {
  /** Holds if the emptiness test evaluates to `true`. */
  predicate isEmpty() { this = TEmptinessCompletion(true) }

  override EmptinessSuccessor getAMatchingSuccessorType() {
    if isEmpty() then result.getValue() = true else result.getValue() = false
  }

  override string toString() { if this.isEmpty() then result = "empty" else result = "non-empty" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a return.
 */
class ReturnCompletion extends Completion, TReturnCompletion {
  override ReturnSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "return" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a break from a loop.
 */
class BreakCompletion extends Completion, TBreakCompletion {
  override BreakSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "break" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a continuation of a loop.
 */
class NextCompletion extends Completion, TNextCompletion {
  override NextSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "next" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a redo of a loop iteration.
 */
class RedoCompletion extends Completion, TRedoCompletion {
  override RedoSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "redo" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a retry.
 */
class RetryCompletion extends Completion, TRetryCompletion {
  override RetrySuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "retry" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a thrown exception.
 */
class RaiseCompletion extends Completion, TRaiseCompletion {
  override RaiseSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "raise" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in an abort/exit.
 */
class ExitCompletion extends Completion, TExitCompletion {
  override ExitSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "exit" }
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
class NestedCompletion extends Completion, TNestedCompletion {
  Completion inner;
  Completion outer;

  NestedCompletion() { this = TNestedCompletion(inner, outer) }

  override Completion getInnerCompletion() { result = inner }

  override Completion getOuterCompletion() { result = outer }

  override SuccessorType getAMatchingSuccessorType() {
    inner = TBreakCompletion() and
    outer = TSimpleCompletion() and
    result instanceof BreakSuccessor
  }

  override string toString() { result = outer + " [" + inner + "]" }
}

private class NestedNormalCompletion extends NormalCompletion, NestedCompletion {
  NestedNormalCompletion() { outer instanceof NormalCompletion }
}
