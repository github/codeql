private import codeql.util.Boolean
private import codeql.rust.controlflow.ControlFlowGraph
private import rust
private import SuccessorType

private newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(Boolean b) or
  TMatchCompletion(Boolean isMatch) or
  TLoopCompletion(TLoopJumpType kind, TLabelType label) {
    label = TNoLabel()
    or
    kind = TBreakJump() and label = TLabel(any(BreakExpr b).getLifetime().getText())
    or
    kind = TContinueJump() and label = TLabel(any(ContinueExpr b).getLifetime().getText())
  } or
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

  final predicate succeeded() { value = true }

  final predicate failed() { value = false }

  /** Gets the dual completion. */
  abstract ConditionalCompletion getDual();
}

/**
 * A completion that represents evaluation of an expression
 * with a Boolean value.
 */
class BooleanCompletion extends ConditionalCompletion, TBooleanCompletion {
  BooleanCompletion() { this = TBooleanCompletion(value) }

  override predicate isValidForSpecific(AstNode e) {
    e = any(IfExpr c).getCondition()
    or
    any(MatchArm arm).getGuard() = e
    or
    exists(BinaryExpr expr |
      expr.getOperatorName() = ["&&", "||"] and
      e = expr.getLhs()
    )
    or
    exists(Expr parent | this.isValidForSpecific(parent) |
      parent =
        any(PrefixExpr expr |
          expr.getOperatorName() = "!" and
          e = expr.getExpr()
        )
      or
      parent =
        any(BinaryExpr expr |
          expr.getOperatorName() = ["&&", "||"] and
          e = expr.getRhs()
        )
      or
      parent = any(IfExpr ie | e = [ie.getThen(), ie.getElse()])
      or
      parent = any(BlockExpr be | e = be.getStmtList().getTailExpr())
    )
  }

  /** Gets the dual Boolean completion. */
  override BooleanCompletion getDual() { result = TBooleanCompletion(value.booleanNot()) }

  override BooleanSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  override string toString() { result = "boolean(" + value + ")" }
}

/**
 * A completion that represents the result of a pattern match.
 */
class MatchCompletion extends TMatchCompletion, ConditionalCompletion {
  MatchCompletion() { this = TMatchCompletion(value) }

  override predicate isValidForSpecific(AstNode e) { e instanceof Pat }

  override MatchSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  /** Gets the dual match completion. */
  override MatchCompletion getDual() { result = TMatchCompletion(value.booleanNot()) }

  override string toString() { result = "match(" + value + ")" }
}

/**
 * A completion that represents a break or a continue.
 */
class LoopJumpCompletion extends TLoopCompletion, Completion {
  override LoopJumpSuccessor getAMatchingSuccessorType() {
    result = TLoopSuccessor(this.getKind(), this.getLabelType())
  }

  final TLoopJumpType getKind() { this = TLoopCompletion(result, _) }

  final TLabelType getLabelType() { this = TLoopCompletion(_, result) }

  final predicate hasLabel() { this.getLabelType() = TLabel(_) }

  final string getLabelName() { TLabel(result) = this.getLabelType() }

  final predicate isContinue() { this.getKind() = TContinueJump() }

  final predicate isBreak() { this.getKind() = TBreakJump() }

  override predicate isValidForSpecific(AstNode e) {
    this.isBreak() and
    e instanceof BreakExpr and
    (
      not e.(BreakExpr).hasLifetime() and not this.hasLabel()
      or
      e.(BreakExpr).getLifetime().getText() = this.getLabelName()
    )
    or
    this.isContinue() and
    e instanceof ContinueExpr and
    (
      not e.(ContinueExpr).hasLifetime() and not this.hasLabel()
      or
      e.(ContinueExpr).getLifetime().getText() = this.getLabelName()
    )
  }

  override string toString() { result = this.getAMatchingSuccessorType().toString() }
}

/**
 * A completion that represents a return.
 */
class ReturnCompletion extends TReturnCompletion, Completion {
  override ReturnSuccessor getAMatchingSuccessorType() { any() }

  override predicate isValidForSpecific(AstNode e) { e instanceof ReturnExpr }

  override string toString() { result = "return" }
}

/** Hold if `c` represents normal evaluation of a statement or an expression. */
predicate completionIsNormal(Completion c) { c instanceof NormalCompletion }

/** Hold if `c` represents simple and normal evaluation of a statement or an expression. */
predicate completionIsSimple(Completion c) { c instanceof SimpleCompletion }

/** Holds if `c` is a valid completion for `n`. */
predicate completionIsValidFor(Completion c, AstNode n) { c.isValidFor(n) }
