/**
 * Provides classes and predicates for representing completions.
 */

/*
 * A completion represents how a statement or expression terminates.
 *
 * There are five kinds of completions: normal completion,
 * `return` completion, `break` completion,
 * `continue` completion, and `throw` completion.
 *
 * Normal completions are further subdivided into boolean completions and all
 * other normal completions. A boolean completion adds the information that the
 * cfg node terminated with the given boolean value due to a subexpression
 * terminating with the other given boolean value. This is only
 * relevant for conditional contexts in which the value controls the
 * control-flow successor.
 */

import java

/**
 * A label of a `LabeledStmt`.
 */
newtype Label = MkLabel(string l) { exists(LabeledStmt lbl | l = lbl.getLabel()) }

/**
 * Either a `Label` or nothing.
 */
newtype MaybeLabel =
  JustLabel(Label l) or
  NoLabel()

/**
 * A completion of a statement or an expression.
 */
newtype Completion =
  /**
   * The statement or expression completes normally and continues to the next statement.
   */
  NormalCompletion() or
  /**
   * The statement or expression completes by returning from the function.
   */
  ReturnCompletion() or
  /**
   * The expression completes with value `outerValue` overall and with the last control
   * flow node having value `innerValue`.
   */
  BooleanCompletion(boolean outerValue, boolean innerValue) {
    (outerValue = true or outerValue = false) and
    (innerValue = true or innerValue = false)
  } or
  /**
   * The expression or statement completes via a `break` statement.
   */
  BreakCompletion(MaybeLabel l) or
  /**
   * The expression or statement completes via a `yield` statement.
   */
  YieldCompletion(NormalOrBooleanCompletion c) or
  /**
   * The expression or statement completes via a `continue` statement.
   */
  ContinueCompletion(MaybeLabel l) or
  /**
   * The expression or statement completes by throwing a `ThrowableType`.
   */
  ThrowCompletion(ThrowableType tt)

/** A completion that is either a `NormalCompletion` or a `BooleanCompletion`. */
class NormalOrBooleanCompletion extends Completion {
  NormalOrBooleanCompletion() {
    this instanceof NormalCompletion or this instanceof BooleanCompletion
  }

  /** Gets a textual representation of this completion. */
  string toString() { result = "completion" }
}

/** Gets the completion `ContinueCompletion(NoLabel())`. */
ContinueCompletion anonymousContinueCompletion() { result = ContinueCompletion(NoLabel()) }

/** Gets the completion `ContinueCompletion(JustLabel(l))`. */
ContinueCompletion labelledContinueCompletion(Label l) { result = ContinueCompletion(JustLabel(l)) }

/** Gets the completion `BreakCompletion(NoLabel())`. */
BreakCompletion anonymousBreakCompletion() { result = BreakCompletion(NoLabel()) }

/** Gets the completion `BreakCompletion(JustLabel(l))`. */
BreakCompletion labelledBreakCompletion(Label l) { result = BreakCompletion(JustLabel(l)) }

/** Gets the completion `BooleanCompletion(value, value)`. */
Completion basicBooleanCompletion(boolean value) { result = BooleanCompletion(value, value) }
