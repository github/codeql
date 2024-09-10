private import codeql.util.Boolean
private import codeql.rust.controlflow.ControlFlowGraph
private import rust
private import SuccessorType
private import SuccessorTypes

private newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(Boolean b) or
  TReturnCompletion()

/** A completion of a statement or an expression. */
abstract class Completion extends TCompletion {
  /** Gets a textual representation of this completion. */
  abstract string toString();

  predicate isValidForSpecific(AstNode e) { none() }

  predicate isValidFor(AstNode e) { this.isValidForSpecific(e) }

  /** Gets a successor type that matches this completion. */
  abstract SuccessorType getAMatchingSuccessorType();
}

/**
 * A completion that represents normal evaluation of a statement or an
 * expression.
 */
abstract class NormalCompletion extends Completion { }

/** A simple (normal) completion. */
class SimpleCompletion extends NormalCompletion, TSimpleCompletion {
  override NormalSuccessor getAMatchingSuccessorType() { any() }

  // `SimpleCompletion` is the "default" completion type, thus it is valid for
  // any node where there isn't another more specific completion type.
  override predicate isValidFor(AstNode e) { not any(Completion c).isValidForSpecific(e) }

  override string toString() { result = "simple" }
}

/**
 * A completion that represents evaluation of an expression, whose value
 * determines the successor.
 */
abstract class ConditionalCompletion extends NormalCompletion {
  boolean value;

  bindingset[value]
  ConditionalCompletion() { any() }

  /** Gets the Boolean value of this conditional completion. */
  final boolean getValue() { result = value }

  /** Gets the dual completion. */
  abstract ConditionalCompletion getDual();
}

/**
 * A completion that represents evaluation of an expression
 * with a Boolean value.
 */
class BooleanCompletion extends ConditionalCompletion, TBooleanCompletion {
  BooleanCompletion() { this = TBooleanCompletion(value) }

  override predicate isValidForSpecific(AstNode e) { e = any(If c).getCondition() }

  /** Gets the dual Boolean completion. */
  override BooleanCompletion getDual() { result = TBooleanCompletion(value.booleanNot()) }

  override BooleanSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  override string toString() { result = "boolean(" + value + ")" }
}

/**
 * A completion that represents a return.
 */
class ReturnCompletion extends TReturnCompletion, Completion {
  override ReturnSuccessor getAMatchingSuccessorType() { any() }

  override predicate isValidForSpecific(AstNode e) { e instanceof Return }

  override string toString() { result = "return" }
}

/** Hold if `c` represents normal evaluation of a statement or an expression. */
predicate completionIsNormal(Completion c) { c instanceof NormalCompletion }

/** Hold if `c` represents simple and normal evaluation of a statement or an expression. */
predicate completionIsSimple(Completion c) { c instanceof SimpleCompletion }

/** Holds if `c` is a valid completion for `n`. */
predicate completionIsValidFor(Completion c, AstNode n) { c.isValidFor(n) }
