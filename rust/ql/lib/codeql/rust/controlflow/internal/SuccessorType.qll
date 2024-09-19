private import rust
private import codeql.util.Boolean

newtype TLoopJumpType =
  TContinueJump() or
  TBreakJump()

newtype TLabelType =
  TLabel(string s) { any(Label l).getLifetime().getText() = s } or
  TNoLabel()

cached
newtype TSuccessorType =
  TSuccessorSuccessor() or
  TBooleanSuccessor(Boolean b) or
  TMatchSuccessor(Boolean b) or
  TLoopSuccessor(TLoopJumpType kind, TLabelType label) or
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

/** A Boolean control flow successor for a boolean conditon. */
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

/**
 * A control flow successor of a loop control flow expression, `continue` or `break`.
 */
final class LoopJumpSuccessor extends SuccessorTypeImpl, TLoopSuccessor {
  final private TLoopJumpType getKind() { this = TLoopSuccessor(result, _) }

  final private TLabelType getLabelType() { this = TLoopSuccessor(_, result) }

  final predicate hasLabel() { this.getLabelType() = TLabel(_) }

  final string getLabelName() { this = TLoopSuccessor(_, TLabel(result)) }

  final predicate isContinue() { this.getKind() = TContinueJump() }

  final predicate isBreak() { this.getKind() = TBreakJump() }

  final override string toString() {
    exists(string kind, string label |
      (if this.isContinue() then kind = "continue" else kind = "break") and
      (if this.hasLabel() then label = "(" + this.getLabelName() + ")" else label = "") and
      result = kind + label
    )
  }
}

/**
 * A `return` control flow successor.
 */
final class ReturnSuccessor extends SuccessorTypeImpl, TReturnSuccessor {
  final override string toString() { result = "return" }
}
