private import codeql.util.Boolean

cached
newtype TSuccessorType =
  TSuccessorSuccessor() or
  TBooleanSuccessor(Boolean b) or
  TReturnSuccessor()

/** The type of a control flow successor. */
class SuccessorType extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  string toString() { none() }
}

/** Provides different types of control flow successor types. */
module SuccessorTypes {
  /** A normal control flow successor. */
  class NormalSuccessor extends SuccessorType, TSuccessorSuccessor {
    final override string toString() { result = "successor" }
  }

  /** A conditional control flow successor. */
  abstract class ConditionalSuccessor extends SuccessorType {
    boolean value;

    bindingset[value]
    ConditionalSuccessor() { any() }

    /** Gets the Boolean value of this successor. */
    final boolean getValue() { result = value }

    override string toString() { result = this.getValue().toString() }
  }

  /** A Boolean control flow successor. */
  class BooleanSuccessor extends ConditionalSuccessor, TBooleanSuccessor {
    BooleanSuccessor() { this = TBooleanSuccessor(value) }
  }

  /**
   * A `return` control flow successor.
   */
  class ReturnSuccessor extends SuccessorType, TReturnSuccessor {
    final override string toString() { result = "return" }
  }
}
