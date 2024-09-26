private import rust
private import codeql.util.Boolean
private import Completion

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
  TLoopSuccessor(TLoopJumpType kind, TLabelType label) { exists(TLoopCompletion(kind, label)) } or
  TReturnSuccessor()

/** The type of a control flow successor. */
abstract class SuccessorTypeImpl extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  abstract string toString();
}

/** A normal control flow successor. */
class NormalSuccessorImpl extends SuccessorTypeImpl, TSuccessorSuccessor {
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
 * A control flow successor of a loop control flow expression, `continue` or `break`.
 */
class LoopJumpSuccessorImpl extends SuccessorTypeImpl, TLoopSuccessor {
  private TLoopJumpType getKind() { this = TLoopSuccessor(result, _) }

  private TLabelType getLabelType() { this = TLoopSuccessor(_, result) }

  predicate hasLabel() { this.getLabelType() = TLabel(_) }

  string getLabelName() { this = TLoopSuccessor(_, TLabel(result)) }

  predicate isContinue() { this.getKind() = TContinueJump() }

  predicate isBreak() { this.getKind() = TBreakJump() }

  override string toString() {
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
class ReturnSuccessorImpl extends SuccessorTypeImpl, TReturnSuccessor {
  override string toString() { result = "return" }
}
