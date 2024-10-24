private import codeql.util.Boolean
private import codeql.rust.controlflow.ControlFlowGraph
private import rust
private import SuccessorType

newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(Boolean b) or
  TMatchCompletion(Boolean isMatch) or
  TBreakCompletion() or
  TContinueCompletion() or
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

/** Holds if node `le` has the constant Boolean value `value`. */
private predicate isBooleanConstant(LiteralExpr le, Boolean value) {
  le.getTextValue() = value.toString()
}

/**
 * A completion that represents evaluation of an expression
 * with a Boolean value.
 */
class BooleanCompletion extends ConditionalCompletion, TBooleanCompletion {
  BooleanCompletion() { this = TBooleanCompletion(value) }

  private predicate isValidForSpecific0(AstNode e) {
    e = any(IfExpr c).getCondition()
    or
    e = any(WhileExpr c).getCondition()
    or
    any(MatchGuard guard).getCondition() = e
    or
    e = any(BinaryLogicalOperation blo).getLhs()
    or
    exists(Expr parent | this.isValidForSpecific0(parent) |
      e = parent.(ParenExpr).getExpr()
      or
      e = parent.(LogicalNotExpr).getExpr()
      or
      e = parent.(BinaryLogicalOperation).getRhs()
      or
      parent = any(IfExpr ie | e = [ie.getThen(), ie.getElse()])
      or
      e = parent.(MatchExpr).getAnArm().getExpr()
      or
      e = parent.(BlockExpr).getStmtList().getTailExpr()
      or
      e = any(BreakExpr be | be.getTarget() = parent).getExpr()
    )
  }

  override predicate isValidForSpecific(AstNode e) {
    this.isValidForSpecific0(e) and
    (
      isBooleanConstant(e, value)
      or
      not isBooleanConstant(e, _)
    )
  }

  /** Gets the dual Boolean completion. */
  override BooleanCompletion getDual() { result = TBooleanCompletion(value.booleanNot()) }

  override BooleanSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  override string toString() { result = "boolean(" + value + ")" }
}

/** Holds if `pat` is guaranteed to match at the point in the AST where it occurs. */
pragma[nomagic]
private predicate isExhaustiveMatch(Pat pat) {
  (
    pat instanceof WildcardPat
    or
    pat = any(IdentPat ip | not ip.hasPat() and ip = any(Variable v).getPat())
    or
    pat instanceof RestPat
    or
    // `let` statements without an `else` branch must be exhaustive
    pat = any(LetStmt let | not let.hasLetElse()).getPat()
    or
    // `match` expressions must be exhaustive, so last arm cannot fail
    pat = any(MatchExpr me).getLastArm().getPat()
    or
    // macro invocations are exhaustive if their expansion is
    pat = any(MacroPat mp | isExhaustiveMatch(mp.getMacroCall().getExpanded()))
    or
    // parameter patterns must be exhaustive
    pat = any(Param p).getPat()
  ) and
  not pat = any(ForExpr for).getPat() // workaround until `for` loops are desugared
  or
  exists(Pat parent | isExhaustiveMatch(parent) |
    pat = parent.(BoxPat).getPat()
    or
    pat = parent.(IdentPat).getPat()
    or
    pat = parent.(MacroPat).getMacroCall().getExpanded()
    or
    pat = parent.(ParenPat).getPat()
    or
    pat = parent.(RecordPat).getRecordPatFieldList().getField(_).getPat()
    or
    pat = parent.(RefPat).getPat()
    or
    pat = parent.(TuplePat).getAField()
    or
    pat = parent.(TupleStructPat).getAField()
    or
    pat = parent.(OrPat).getLastPat()
  )
}

/**
 * A completion that represents the result of a pattern match.
 */
class MatchCompletion extends TMatchCompletion, ConditionalCompletion {
  MatchCompletion() { this = TMatchCompletion(value) }

  override predicate isValidForSpecific(AstNode e) {
    e instanceof Pat and
    if isExhaustiveMatch(e) then value = true else any()
    or
    e instanceof TryExpr and value = true
  }

  override MatchSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  /** Gets the dual match completion. */
  override MatchCompletion getDual() { result = TMatchCompletion(value.booleanNot()) }

  override string toString() { result = "match(" + value + ")" }
}

/**
 * A completion that represents a `break`.
 */
class BreakCompletion extends TBreakCompletion, Completion {
  override BreakSuccessor getAMatchingSuccessorType() { any() }

  override predicate isValidForSpecific(AstNode e) { e instanceof BreakExpr }

  override string toString() { result = this.getAMatchingSuccessorType().toString() }
}

/**
 * A completion that represents a `continue`.
 */
class ContinueCompletion extends TContinueCompletion, Completion {
  override ContinueSuccessor getAMatchingSuccessorType() { any() }

  override predicate isValidForSpecific(AstNode e) { e instanceof ContinueExpr }

  override string toString() { result = this.getAMatchingSuccessorType().toString() }
}

/**
 * A completion that represents a return.
 */
class ReturnCompletion extends TReturnCompletion, Completion {
  override ReturnSuccessor getAMatchingSuccessorType() { any() }

  override predicate isValidForSpecific(AstNode e) {
    e instanceof ReturnExpr or e instanceof TryExpr
  }

  override string toString() { result = "return" }
}

/** Hold if `c` represents normal evaluation of a statement or an expression. */
predicate completionIsNormal(Completion c) { c instanceof NormalCompletion }

/** Hold if `c` represents simple and normal evaluation of a statement or an expression. */
predicate completionIsSimple(Completion c) { c instanceof SimpleCompletion }

/** Holds if `c` is a valid completion for `n`. */
predicate completionIsValidFor(Completion c, AstNode n) { c.isValidFor(n) }
