private import rust
private import codeql.util.Boolean
private import Completion
private import codeql.rust.internal.CachedStages

cached
newtype TSuccessorType =
  TNormalSuccessor() { Stages::CfgStage::ref() } or
  TBooleanSuccessor(Boolean b) or
  TMatchSuccessor(Boolean b) or
  TBreakSuccessor() or
  TContinueSuccessor() or
  TReturnSuccessor()

/** The type of a control flow successor. */
abstract class SuccessorTypeImpl extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  abstract string toString();
}

/** A normal control flow successor. */
class NormalSuccessorImpl extends SuccessorTypeImpl, TNormalSuccessor {
  override string toString() { result = "successor" }
}

/** A conditional control flow successor. */
abstract class ConditionalSuccessorImpl extends SuccessorTypeImpl {
  boolean value;

  bindingset[value]
  ConditionalSuccessorImpl() { exists(value) }

  /** Gets the Boolean value of this successor. */
  boolean getValue() { result = value }
}

/** A Boolean control flow successor for a boolean conditon. */
class BooleanSuccessorImpl extends ConditionalSuccessorImpl, TBooleanSuccessor {
  BooleanSuccessorImpl() { this = TBooleanSuccessor(value) }

  override string toString() { result = this.getValue().toString() }
}

/**
 * A control flow successor of a pattern match.
 */
class MatchSuccessorImpl extends ConditionalSuccessorImpl, TMatchSuccessor {
  MatchSuccessorImpl() { this = TMatchSuccessor(value) }

  override string toString() {
    if this.getValue() = true then result = "match" else result = "no-match"
  }
}

/**
 * A control flow successor of a `break` expression.
 */
class BreakSuccessorImpl extends SuccessorTypeImpl, TBreakSuccessor {
  override string toString() { result = "break" }
}

/**
 * A control flow successor of a `continue` expression.
 */
class ContinueSuccessorImpl extends SuccessorTypeImpl, TContinueSuccessor {
  override string toString() { result = "continue" }
}

/**
 * A `return` control flow successor.
 */
class ReturnSuccessorImpl extends SuccessorTypeImpl, TReturnSuccessor {
  override string toString() { result = "return" }
}
