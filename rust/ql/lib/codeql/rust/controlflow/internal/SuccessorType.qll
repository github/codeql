private import codeql.util.Boolean

cached
newtype TSuccessorType =
  TSuccessorSuccessor() or
  TBooleanSuccessor(Boolean b) or
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

  override string toString() { result = this.getValue().toString() }
}

/** A Boolean control flow successor. */
final class BooleanSuccessor extends ConditionalSuccessor, TBooleanSuccessor {
  BooleanSuccessor() { this = TBooleanSuccessor(value) }
}

/**
 * A `return` control flow successor.
 */
final class ReturnSuccessor extends SuccessorTypeImpl, TReturnSuccessor {
  final override string toString() { result = "return" }
}
