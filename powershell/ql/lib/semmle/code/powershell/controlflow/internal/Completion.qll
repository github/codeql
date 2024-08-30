/**
 * Provides classes representing control flow completions.
 *
 * A completion represents how a statement or expression terminates.
 */

private import powershell
private import semmle.code.powershell.controlflow.ControlFlowGraph
private import ControlFlowGraphImpl as CfgImpl
private import SuccessorTypes

// TODO: We most likely need a TrapCompletion as well
private newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(boolean b) { b in [false, true] } or
  TReturnCompletion() or
  TBreakCompletion() or
  TRaiseCompletion() or
  TExitCompletion()

pragma[noinline]
private predicate completionIsValidForStmt(Ast n, Completion c) { none() }

/** A completion of a statement or an expression. */
abstract class Completion extends TCompletion {
  private predicate isValidForSpecific0(Ast n) {
    completionIsValidForStmt(n, this)
    or
    mustHaveBooleanCompletion(n) and
    (
      exists(boolean value | isBooleanConstant(n, value) | this = TBooleanCompletion(value))
      or
      not isBooleanConstant(n, _) and
      this = TBooleanCompletion(_)
    )
  }

  private predicate isValidForSpecific(Ast n) { this.isValidForSpecific0(n) }

  /** Holds if this completion is valid for node `n`. */
  predicate isValidFor(Ast n) {
    this.isValidForSpecific(n)
    or
    not any(Completion c).isValidForSpecific(n) and
    this = TSimpleCompletion()
  }

  /**
   * Holds if this completion will continue a loop when it is the completion
   * of a loop body.
   */
  predicate continuesLoop() { this instanceof NormalCompletion }

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
private predicate isBooleanConstant(Ast n, boolean value) {
  mustHaveBooleanCompletion(n) and
  none() // TODO
}

/**
 * Holds if a normal completion of `n` must be a Boolean completion.
 */
private predicate mustHaveBooleanCompletion(Ast n) { inBooleanContext(n) }

/**
 * Holds if `n` is used in a Boolean context. That is, the value
 * that `n` evaluates to determines a true/false branch successor.
 */
private predicate inBooleanContext(Ast n) { none() }

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
 * the successor.
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
class BooleanCompletion extends ConditionalCompletion, NormalCompletion, TBooleanCompletion {
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
