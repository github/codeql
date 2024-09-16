private import codeql.util.Boolean

cached
newtype TSuccessorType =
  TSuccessorSuccessor() or
  TBooleanSuccessor(Boolean b) or
  TMatchSuccessor(Boolean b) or
  TBreakSuccessor() or
  TContinueSuccessor() or
  TReturnSuccessor()

/** The type of a control flow successor. */
abstract private class SuccessorTypeImpl extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  abstract string toString();
}

final class SuccessorType = SuccessorTypeImpl;

/** A normal control flow successor. */
final class NormalSuccessor extends SuccessorTypeImpl, TSuccessorSuccessor {
  final override string toString() { result = "successor" }
}

/** A conditional control flow successor. */
abstract private class ConditionalSuccessor extends SuccessorTypeImpl {
  boolean value;

  bindingset[value]
  ConditionalSuccessor() { any() }

  /** Gets the Boolean value of this successor. */
  final boolean getValue() { result = value }
}

/** A boolean control flow successor for a boolean conditon. */
final class BooleanSuccessor extends ConditionalSuccessor, TBooleanSuccessor {
  BooleanSuccessor() { this = TBooleanSuccessor(value) }

  override string toString() { result = this.getValue().toString() }
}

/**
 * A control flow successor of a pattern match.
 */
final class MatchSuccessor extends ConditionalSuccessor, TMatchSuccessor {
  MatchSuccessor() { this = TMatchSuccessor(value) }

  override string toString() {
    if this.getValue() = true then result = "match" else result = "no-match"
  }
}

/** A `break` control flow successor. */
final class BreakSuccessor extends SuccessorTypeImpl, TBreakSuccessor {
  final override string toString() { result = "break" }
}

/** A `continue` control flow successor. */
final class ContinueSuccessor extends SuccessorTypeImpl, TContinueSuccessor {
  final override string toString() { result = "continue" }
}

/**
 * A `return` control flow successor.
 */
final class ReturnSuccessor extends SuccessorTypeImpl, TReturnSuccessor {
  final override string toString() { result = "return" }
}
