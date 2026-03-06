/**
 * Provides classes representing control flow completions.
 *
 * A completion represents how a statement or expression terminates.
 */

private import codeql.php.AST
private import codeql.php.controlflow.ControlFlowGraph
private import ControlFlowGraphImpl as CfgImpl

private newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(boolean b) { b in [false, true] } or
  TReturnCompletion() or
  TBreakCompletion() or
  TContinueCompletion() or
  TThrowCompletion() or
  TExitCompletion()

/**
 * Holds if `c` is a valid completion for node `n` based on its statement type.
 */
private predicate completionIsValidForStmt(AstNode n, Completion c) {
  n instanceof BreakStmt and c = TBreakCompletion()
  or
  n instanceof ContinueStmt and c = TContinueCompletion()
  or
  n instanceof ReturnStmt and c = TReturnCompletion()
  or
  n instanceof ThrowExpr and c = TThrowCompletion()
}

/**
 * Holds if `n` is used in a Boolean context. That is, the value
 * that `n` evaluates to determines a true/false branch successor.
 */
private predicate inBooleanContext(AstNode n) {
  // Condition of if/elseif
  exists(IfStmt ifStmt | n = ifStmt.getCondition())
  or
  exists(ElseIfClause clause | n = clause.getCondition())
  or
  // Condition of while
  exists(WhileStmt whileStmt | n = whileStmt.getCondition())
  or
  // Condition of do-while
  exists(DoWhileStmt doWhile | n = doWhile.getCondition())
  or
  // Condition of for
  exists(ForStmt forStmt | n = forStmt.getCondition())
  or
  // Condition of ternary
  exists(ConditionalExpr cond | n = cond.getCondition())
  or
  // Logical operators: left operand is always in boolean context
  exists(BinaryExpr bin |
    bin.getOperator() = ["&&", "||", "and", "or"] and
    n = bin.getLeftOperand()
  )
  or
  // Negation operand
  exists(UnaryExpr unary |
    unary.getOperator() = "!" and
    n = unary.getOperand()
  )
}

/**
 * Holds if a normal completion of `n` must be a Boolean completion.
 */
private predicate mustHaveBooleanCompletion(AstNode n) { inBooleanContext(n) }

/** A completion of a statement or an expression. */
abstract class Completion extends TCompletion {
  private predicate isValidForSpecific(AstNode n) {
    completionIsValidForStmt(n, this)
    or
    mustHaveBooleanCompletion(n) and
    this = TBooleanCompletion(_)
  }

  /** Holds if this completion is valid for node `n`. */
  predicate isValidFor(AstNode n) {
    this.isValidForSpecific(n)
    or
    not any(Completion c).isValidForSpecific(n) and
    this = TSimpleCompletion()
  }

  /**
   * Holds if this completion will continue a loop when it is the completion
   * of a loop body.
   */
  predicate continuesLoop() {
    this instanceof NormalCompletion or
    this instanceof ContinueCompletion
  }

  /** Gets a successor type that matches this completion. */
  abstract SuccessorType getAMatchingSuccessorType();

  /** Gets a textual representation of this completion. */
  abstract string toString();
}

/** A completion that represents normal evaluation. */
abstract class NormalCompletion extends Completion { }

/** A simple (normal) completion. */
class SimpleCompletion extends NormalCompletion, TSimpleCompletion {
  override SuccessorType getAMatchingSuccessorType() { result instanceof DirectSuccessor }

  override string toString() { result = "simple" }
}

/** A Boolean completion. */
class BooleanCompletion extends NormalCompletion, TBooleanCompletion {
  boolean value;

  BooleanCompletion() { this = TBooleanCompletion(value) }

  /** Gets the Boolean value of this completion. */
  boolean getValue() { result = value }

  override SuccessorType getAMatchingSuccessorType() {
    result.(BooleanSuccessor).getValue() = value
  }

  override string toString() { result = "boolean(" + value + ")" }
}

/** A return completion. */
class ReturnCompletion extends Completion, TReturnCompletion {
  override SuccessorType getAMatchingSuccessorType() { result instanceof ReturnSuccessor }

  override string toString() { result = "return" }
}

/** A break completion. */
class BreakCompletion extends Completion, TBreakCompletion {
  override SuccessorType getAMatchingSuccessorType() { result instanceof BreakSuccessor }

  override string toString() { result = "break" }
}

/** A continue completion. */
class ContinueCompletion extends Completion, TContinueCompletion {
  override SuccessorType getAMatchingSuccessorType() { result instanceof ContinueSuccessor }

  override string toString() { result = "continue" }
}

/** A throw completion (exception). */
class ThrowCompletion extends Completion, TThrowCompletion {
  override SuccessorType getAMatchingSuccessorType() { result instanceof ExceptionSuccessor }

  override string toString() { result = "throw" }
}

/** An exit completion (die/exit). */
class ExitCompletion extends Completion, TExitCompletion {
  override SuccessorType getAMatchingSuccessorType() { result instanceof ExitSuccessor }

  override string toString() { result = "exit" }
}

/**
 * A conditional completion, used for splitting.
 */
class ConditionalCompletion extends BooleanCompletion { }
