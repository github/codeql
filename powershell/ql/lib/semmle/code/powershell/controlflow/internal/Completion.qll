/**
 * Provides classes representing control flow completions.
 *
 * A completion represents how a statement or expression terminates.
 */

private import powershell
private import semmle.code.powershell.controlflow.ControlFlowGraph
private import ControlFlowGraphImpl as CfgImpl
private import SuccessorTypes
private import codeql.util.Boolean

// TODO: We most likely need a TrapCompletion as well
private newtype TCompletion =
  TSimpleCompletion() or
  TBooleanCompletion(Boolean b) or
  TReturnCompletion() or
  TBreakCompletion() or
  TContinueCompletion() or
  TThrowCompletion() or
  TExitCompletion() or
  TMatchingCompletion(Boolean b) or
  TEmptinessCompletion(Boolean isEmpty)

private predicate commandThrows(CallExpr c, boolean unconditional) {
  c.getNamedArgument("ErrorAction").getValue().asString() = "Stop" and
  if c.matchesName("Write-Error") then unconditional = true else unconditional = false
}

pragma[noinline]
private predicate completionIsValidForStmt(Ast n, Completion c) {
  n instanceof BreakStmt and
  c instanceof BreakCompletion
  or
  n instanceof ContinueStmt and
  c instanceof ContinueCompletion
  or
  n instanceof ThrowStmt and
  c instanceof ThrowCompletion
  or
  exists(boolean unconditional | commandThrows(n, unconditional) |
    c instanceof ThrowCompletion
    or
    unconditional = false and
    c instanceof SimpleCompletion
  )
  or
  n instanceof ExitStmt and
  c instanceof ExitCompletion
}

/** A completion of a statement or an expression. */
abstract class Completion extends TCompletion {
  private predicate isValidForSpecific0(Ast n) {
    completionIsValidForStmt(n, this)
    or
    mustHaveBooleanCompletion(n) and
    (
      exists(boolean value | isBooleanConstant(n, value) | this = TBooleanCompletion(value))
      or
      not isBooleanConstant(n, _) and
      this = TBooleanCompletion(_)
    )
    or
    mustHaveMatchingCompletion(n) and
    (
      exists(boolean value | isMatchingConstant(n, value) | this = TMatchingCompletion(value))
      or
      not isMatchingConstant(n, _) and
      this = TMatchingCompletion(_)
    )
    or
    mustHaveEmptinessCompletion(n) and
    this = TEmptinessCompletion(_)
  }

  private predicate isValidForSpecific(Ast n) { this.isValidForSpecific0(n) }

  /** Holds if this completion is valid for node `n`. */
  predicate isValidFor(Ast n) {
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

/** Holds if node `n` has the Boolean constant value `value`. */
private predicate isBooleanConstant(Ast n, boolean value) {
  mustHaveBooleanCompletion(n) and
  // TODO
  exists(value) and
  none()
}

private predicate isMatchingConstant(Ast n, boolean value) {
  inMatchingContext(n) and
  // TODO
  exists(value) and
  none()
}

/**
 * Holds if a normal completion of `n` must be a Boolean completion.
 */
private predicate mustHaveBooleanCompletion(Ast n) { inBooleanContext(n) }

private predicate mustHaveMatchingCompletion(Ast n) { inMatchingContext(n) }

/**
 * Holds if `n` is used in a Boolean context. That is, the value
 * that `n` evaluates to determines a true/false branch successor.
 */
private predicate inBooleanContext(Ast n) {
  n = any(If ifStmt).getACondition()
  or
  n = any(WhileStmt whileStmt).getCondition()
  or
  n = any(DoWhileStmt doWhileStmt).getCondition()
  or
  n = any(ForStmt forStmt).getCondition()
  or
  n = any(DoUntilStmt doUntilStmt).getCondition()
  or
  exists(ConditionalExpr cond |
    n = cond.getCondition()
    or
    inBooleanContext(cond) and
    n = cond.getABranch()
  )
  or
  exists(LogicalAndExpr parent |
    n = parent.getLeft()
    or
    inBooleanContext(parent) and
    n = parent.getRight()
  )
  or
  exists(LogicalOrExpr parent |
    n = parent.getLeft()
    or
    inBooleanContext(parent) and
    n = parent.getRight()
  )
  or
  n = any(NotExpr parent | inBooleanContext(parent)).getOperand()
  or
  exists(Pipeline pipeline |
    inBooleanContext(pipeline) and
    n = pipeline.getComponent(pipeline.getNumberOfComponents() - 1)
  )
  or
  n = any(ParenExpr parent | inBooleanContext(parent)).getExpr()
}

/**
 * From: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-7.4:
 * ```
 * switch [-regex | -wildcard | -exact] [-casesensitive] (<test-expression>)
 * {
 *    "string" | number | variable | { <value-scriptblock> } { <action-scriptblock> }
 *    default { <action-scriptblock> } # optional
 * }
 * ```
 */
private predicate inMatchingContext(Ast n) {
  n = any(SwitchStmt switch).getAPattern()
  or
  n = any(CatchClause cc).getACatchType()
}

/**
 * Holds if a normal completion of `cfe` must be an emptiness completion. Thats is,
 * whether `cfe` determines whether to execute the body of a `foreach` statement.
 */
private predicate mustHaveEmptinessCompletion(Ast n) {
  n instanceof ForEachStmt
  or
  any(CfgImpl::Trees::ProcessBlockTree pbtree).lastEmptinessCheck(n)
}

/**
 * A completion that represents normal evaluation of a statement or an
 * expression.
 */
abstract class NormalCompletion extends Completion { }

/** A simple (normal) completion. */
class SimpleCompletion extends NormalCompletion, TSimpleCompletion {
  override NormalSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "simple" }
}

/**
 * A completion that represents evaluation of an expression, whose value determines
 * the successor.
 */
abstract class ConditionalCompletion extends NormalCompletion {
  boolean value;

  bindingset[value]
  ConditionalCompletion() { any() }

  /** Gets the Boolean value of this conditional completion. */
  final boolean getValue() { result = value }
}

/**
 * A completion that represents evaluation of an expression
 * with a Boolean value.
 */
class BooleanCompletion extends ConditionalCompletion, TBooleanCompletion {
  BooleanCompletion() { this = TBooleanCompletion(value) }

  /** Gets the dual Boolean completion. */
  BooleanCompletion getDual() { result = TBooleanCompletion(value.booleanNot()) }

  override BooleanSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  override string toString() { result = value.toString() }
}

/** A Boolean `true` completion. */
class TrueCompletion extends BooleanCompletion {
  TrueCompletion() { this.getValue() = true }
}

/** A Boolean `false` completion. */
class FalseCompletion extends BooleanCompletion {
  FalseCompletion() { this.getValue() = false }
}

class MatchCompletion extends ConditionalCompletion, TMatchingCompletion {
  MatchCompletion() { this = TMatchingCompletion(value) }

  override MatchingSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  predicate isMatch() { this.getValue() = true }

  predicate isNonMatch() { this.getValue() = false }

  override string toString() { if this.isMatch() then result = "match" else result = "nonmatch" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a return.
 */
class ReturnCompletion extends Completion, TReturnCompletion {
  override ReturnSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "return" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a break from a loop.
 */
class BreakCompletion extends Completion, TBreakCompletion {
  override BreakSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "break" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a continuation of a loop.
 */
class ContinueCompletion extends Completion, TContinueCompletion {
  override ContinueSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "continue" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a thrown exception.
 */
class ThrowCompletion extends Completion, TThrowCompletion {
  override ThrowSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "throw" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in an abort/exit.
 */
class ExitCompletion extends Completion, TExitCompletion {
  override ExitSuccessor getAMatchingSuccessorType() { any() }

  override string toString() { result = "exit" }
}

/**
 * A completion that represents evaluation of an emptiness test, for example
 * a test in a `foreach` statement.
 */
class EmptinessCompletion extends ConditionalCompletion, TEmptinessCompletion {
  EmptinessCompletion() { this = TEmptinessCompletion(value) }

  /** Holds if the emptiness test evaluates to `true`. */
  predicate isEmpty() { value = true }

  EmptinessCompletion getDual() { result = TEmptinessCompletion(value.booleanNot()) }

  override EmptinessSuccessor getAMatchingSuccessorType() { result.getValue() = value }

  override string toString() { if this.isEmpty() then result = "empty" else result = "non-empty" }
}
