/**
 * INTERNAL: Do not use.
 *
 * Provides classes representing control flow completions.
 *
 * A completion represents how a statement or expression terminates.
 *
 * There are six kinds of completions: normal completion,
 * `return` completion, `break` completion, `continue` completion,
 * `goto` completion, and `throw` completion.
 *
 * Normal completions are further subdivided into Boolean completions and all
 * other normal completions. A Boolean completion adds the information that the
 * expression terminated with the given boolean value due to a subexpression
 * terminating with the other given Boolean value. This is only relevant for
 * conditional contexts in which the value controls the control-flow successor.
 *
 * Goto successors are further subdivided into label gotos, case gotos, and
 * default gotos.
 */

import csharp
private import semmle.code.csharp.commons.Constants
private import semmle.code.csharp.frameworks.System
private import NonReturning

// Internal representation of completions
private newtype TCompletion =
  TNormalCompletion() or
  TBooleanCompletion(boolean outerValue, boolean innerValue) {
    (outerValue = true or outerValue = false) and
    (innerValue = true or innerValue = false)
  } or
  TNullnessCompletion(boolean isNull) { isNull = true or isNull = false } or
  TMatchingCompletion(boolean isMatch) { isMatch = true or isMatch = false } or
  TEmptinessCompletion(boolean isEmpty) { isEmpty = true or isEmpty = false } or
  TReturnCompletion() or
  TBreakCompletion() or
  TBreakNormalCompletion() or
  TContinueCompletion() or
  TGotoLabelCompletion(GotoLabelStmt goto) or
  TGotoCaseCompletion(GotoCaseStmt goto) or
  TGotoDefaultCompletion() or
  TThrowCompletion(ExceptionClass ec) or
  TExitCompletion() or
  TInheritedCompletion(NormalCompletion underlying, InheritableCompletion inherited)

/**
 * A completion of a statement or an expression.
 */
class Completion extends TCompletion {
  /**
   * Holds if this completion is valid for control flow element `cfe`.
   *
   * If `cfe` is part of a `try` statement and `cfe` may throw an exception, this
   * completion can be a throw completion.
   *
   * If `cfe` is used in a Boolean context, this completion is a Boolean completion,
   * otherwise it is a normal non-Boolean completion.
   */
  predicate isValidFor(ControlFlowElement cfe) {
    if cfe instanceof NonReturningCall
    then this = cfe.(NonReturningCall).getACompletion()
    else (
      this = TThrowCompletion(cfe.(TriedControlFlowElement).getAThrownException())
      or
      if cfe instanceof ThrowElement
      then this = TThrowCompletion(cfe.(ThrowElement).getThrownExceptionType())
      else
        if mustHaveBooleanCompletion(cfe)
        then
          exists(boolean value | isBooleanConstant(cfe, value) |
            this = TBooleanCompletion(value, value)
          )
          or
          not isBooleanConstant(cfe, _) and
          exists(boolean b | this = TBooleanCompletion(b, b))
          or
          // Corner case: In `if (x ?? y) { ... }`, `x` must have both a `true`
          // completion, a `false` completion, and a `null` completion (but not a
          // non-`null` completion)
          mustHaveNullnessCompletion(cfe) and
          this = TNullnessCompletion(true)
        else
          if mustHaveNullnessCompletion(cfe)
          then
            exists(boolean value | isNullnessConstant(cfe, value) |
              this = TNullnessCompletion(value)
            )
            or
            not isNullnessConstant(cfe, _) and
            this = TNullnessCompletion(_)
          else
            if mustHaveMatchingCompletion(cfe)
            then
              exists(boolean value | isMatchingConstant(cfe, value) |
                this = TMatchingCompletion(value)
              )
              or
              not isMatchingConstant(cfe, _) and
              this = TMatchingCompletion(_)
            else
              if mustHaveEmptinessCompletion(cfe)
              then this = TEmptinessCompletion(_)
              else
                if cfe instanceof BreakStmt
                then this = TBreakCompletion()
                else
                  if cfe instanceof ContinueStmt
                  then this = TContinueCompletion()
                  else
                    if cfe instanceof GotoDefaultStmt
                    then this = TGotoDefaultCompletion()
                    else
                      if cfe instanceof GotoStmt
                      then
                        this = TGotoLabelCompletion(cfe) or
                        this = TGotoCaseCompletion(cfe)
                      else
                        if cfe instanceof ReturnStmt
                        then this = TReturnCompletion()
                        else
                          if cfe instanceof YieldBreakStmt
                          then
                            // `yield break` behaves like a return statement
                            this = TReturnCompletion()
                          else this = TNormalCompletion()
    )
  }

  /**
   * Holds if this completion will continue a loop when it is the completion
   * of a loop body.
   */
  predicate continuesLoop() {
    this instanceof NormalCompletion or
    this instanceof ContinueCompletion
  }

  /**
   * Gets the source of this completion. This is either the underlying completion,
   * when the completion is inherited, or the completion itself.
   */
  Completion getSourceCompletion() { result = this }

  /** Gets a textual representation of this completion. */
  string toString() { none() }
}

/** Holds if expression `e` has the Boolean constant value `value`. */
private predicate isBooleanConstant(Expr e, boolean value) {
  mustHaveBooleanCompletion(e) and
  (
    e.getValue() = "true" and
    value = true
    or
    e.getValue() = "false" and
    value = false
    or
    isConstantComparison(e, value)
  )
}

/**
 * Holds if expression `e` is constantly `null` (`value = true`) or constantly
 * non-`null` (`value = false`).
 */
private predicate isNullnessConstant(Expr e, boolean value) {
  mustHaveNullnessCompletion(e) and
  exists(Expr stripped | stripped = e.stripCasts() |
    stripped.getType() = any(ValueType t |
        not t instanceof NullableType and
        // Extractor bug: the type of `x?.Length` is reported as `int`, but it should
        // be `int?`
        not getQualifier*(stripped).(QualifiableExpr).isConditional()
      ) and
    value = false
    or
    stripped instanceof NullLiteral and
    value = true
    or
    stripped.hasValue() and
    not stripped instanceof NullLiteral and
    value = false
  )
}

private Expr getQualifier(QualifiableExpr e) {
  // `e.getQualifier()` does not work for calls to extension methods
  result = e.getChildExpr(-1)
}

/**
 * Holds if expression `e` constantly matches (`value = true`) or constantly
 * non-matches (`value = false`).
 */
private predicate isMatchingConstant(Expr e, boolean value) {
  exists(Switch s | mustHaveMatchingCompletion(s, e) |
    exists(Expr stripped | stripped = s.getExpr().stripCasts() |
      exists(Case c, string strippedValue |
        c = s.getACase() and
        e = c.getPattern() and
        strippedValue = stripped.getValue()
      |
        if strippedValue = e.getValue() then value = true else value = false
      )
      or
      exists(Case c, TypePatternExpr tpe, Type t, Type strippedType | c = s.getACase() |
        tpe = c.getPattern() and
        e = tpe and
        t = tpe.getCheckedType() and
        strippedType = stripped.getType() and
        not t.isImplicitlyConvertibleTo(strippedType) and
        not t instanceof Interface and
        not t.containsTypeParameters() and
        not strippedType.containsTypeParameters() and
        value = false
      )
    )
    or
    e instanceof DiscardPatternExpr and
    value = true
  )
}

private class Overflowable extends UnaryOperation {
  Overflowable() {
    not this instanceof UnaryBitwiseOperation and
    this.getType() instanceof IntegralType
  }
}

private class CoreLib extends Assembly {
  CoreLib() { this = any(SystemExceptionClass c).getALocation() }
}

/**
 * Holds if assembly `a` was definitely compiled with core library `core`.
 */
pragma[noinline]
private predicate assemblyCompiledWithCoreLib(Assembly a, CoreLib core) {
  a.getAnAttribute().getType().getBaseClass*().(SystemAttributeClass).getALocation() = core
}

/** A control flow element that is inside a `try` block. */
private class TriedControlFlowElement extends ControlFlowElement {
  TryStmt try;

  TriedControlFlowElement() { this = try.getATriedElement() }

  /**
   * Gets an exception class that is potentially thrown by this element, if any.
   */
  private Class getAThrownException0() {
    this instanceof Overflowable and
    result instanceof SystemOverflowExceptionClass
    or
    this.(CastExpr).getType() instanceof IntegralType and
    result instanceof SystemOverflowExceptionClass
    or
    invalidCastCandidate(this) and
    result instanceof SystemInvalidCastExceptionClass
    or
    this instanceof Call and
    result instanceof SystemExceptionClass
    or
    this = any(MemberAccess ma |
        not ma.isConditional() and
        ma.getQualifier() = any(Expr e | not e instanceof TypeAccess) and
        result instanceof SystemNullReferenceExceptionClass
      )
    or
    this instanceof DelegateCreation and
    result instanceof SystemOutOfMemoryExceptionClass
    or
    this instanceof ArrayCreation and
    result instanceof SystemOutOfMemoryExceptionClass
    or
    this = any(AddExpr ae |
        ae.getType() instanceof StringType and
        result instanceof SystemOutOfMemoryExceptionClass
        or
        ae.getType() instanceof IntegralType and
        result instanceof SystemOverflowExceptionClass
      )
    or
    this = any(SubExpr se |
        se.getType() instanceof IntegralType and
        result instanceof SystemOverflowExceptionClass
      )
    or
    this = any(MulExpr me |
        me.getType() instanceof IntegralType and
        result instanceof SystemOverflowExceptionClass
      )
    or
    this = any(DivExpr de |
        not de.getDenominator().getValue().toFloat() != 0 and
        result instanceof SystemDivideByZeroExceptionClass
      )
    or
    this instanceof RemExpr and
    result instanceof SystemDivideByZeroExceptionClass
    or
    this instanceof DynamicExpr and
    result instanceof SystemExceptionClass
    or
    this instanceof StringLiteral and
    result instanceof SystemOutOfMemoryExceptionClass
  }

  private CoreLib getCoreLibFromACatchClause() {
    exists(SpecificCatchClause scc | scc = try.getACatchClause() |
      result = scc.getCaughtExceptionType().getBaseClass*().(SystemExceptionClass).getALocation()
    )
  }

  private CoreLib getCoreLib() {
    result = this.getCoreLibFromACatchClause()
    or
    not exists(this.getCoreLibFromACatchClause()) and
    assemblyCompiledWithCoreLib(this.getAssembly(), result)
  }

  pragma[noinline]
  private Class getAThrownExceptionFromPlausibleCoreLib(string name) {
    result = this.getAThrownException0() and
    name = result.getQualifiedName() and
    (
      not exists(this.getCoreLib())
      or
      this.getCoreLib() = result.getALocation()
    )
  }

  Class getAThrownException() {
    exists(string name | result = this.getAThrownExceptionFromPlausibleCoreLib(name) |
      result = min(Class c |
          c = this.getAThrownExceptionFromPlausibleCoreLib(name)
        |
          c order by c.getLocation().(Assembly).getFullName()
        )
    )
  }
}

pragma[noinline]
private predicate invalidCastCandidate(CastExpr ce) {
  ce.getType() = ce.getExpr().getType().(ValueOrRefType).getASubType+()
}

/**
 * Holds if a normal completion of `e` must be a Boolean completion.
 */
private predicate mustHaveBooleanCompletion(Expr e) {
  inBooleanContext(e, _) and
  not inBooleanContext(e.getAChildExpr(), true)
}

/**
 * Holds if `e` is used in a Boolean context. That is, whether the value
 * that `e` evaluates to determines a true/false branch successor.
 *
 * `isBooleanCompletionForParent` indicates whether the Boolean completion
 * for `e` will be the Boolean completion for `e`'s parent. For example,
 * if `e = B` and the parent is `A && B`, then the Boolean completion of
 * `B` is the Boolean completion of `A && B`.
 */
private predicate inBooleanContext(Expr e, boolean isBooleanCompletionForParent) {
  exists(IfStmt is | is.getCondition() = e | isBooleanCompletionForParent = false)
  or
  exists(LoopStmt ls | ls.getCondition() = e | isBooleanCompletionForParent = false)
  or
  exists(Case c | c.getCondition() = e | isBooleanCompletionForParent = false)
  or
  exists(SpecificCatchClause scc | scc.getFilterClause() = e | isBooleanCompletionForParent = false)
  or
  exists(LogicalNotExpr lne | lne.getAnOperand() = e |
    inBooleanContext(lne, _) and
    isBooleanCompletionForParent = true
  )
  or
  exists(LogicalAndExpr lae |
    lae.getLeftOperand() = e and
    isBooleanCompletionForParent = false
    or
    lae.getRightOperand() = e and
    inBooleanContext(lae, _) and
    isBooleanCompletionForParent = true
  )
  or
  exists(LogicalOrExpr lae |
    lae.getLeftOperand() = e and
    isBooleanCompletionForParent = false
    or
    lae.getRightOperand() = e and
    inBooleanContext(lae, _) and
    isBooleanCompletionForParent = true
  )
  or
  exists(ConditionalExpr ce |
    ce.getCondition() = e and
    isBooleanCompletionForParent = false
    or
    (ce.getThen() = e or ce.getElse() = e) and
    inBooleanContext(ce, _) and
    isBooleanCompletionForParent = true
  )
  or
  exists(NullCoalescingExpr nce | nce.getAnOperand() = e |
    inBooleanContext(nce, _) and
    isBooleanCompletionForParent = true
  )
  or
  exists(SwitchExpr se |
    inBooleanContext(se, _) and
    e = se.getACase().getBody() and
    isBooleanCompletionForParent = true
  )
}

/**
 * Holds if a normal completion of `e` must be a nullness completion.
 */
private predicate mustHaveNullnessCompletion(Expr e) {
  inNullnessContext(e, _) and
  not inNullnessContext(e.getAChildExpr(), true)
}

/**
 * Holds if `e` is used in a nullness context. That is, whether the value
 * that `e` evaluates to determines a `null`/non-`null` branch successor.
 *
 * `isNullnessCompletionForParent` indicates whether the nullness completion
 * for `e` will be the nullness completion for `e`'s parent. For example,
 * if `e = A` and the parent is `A ?? B`, then the nullness completion of `B`
 * is the nullness completion of `A ?? B`.
 */
private predicate inNullnessContext(Expr e, boolean isNullnessCompletionForParent) {
  exists(NullCoalescingExpr nce | e = nce.getLeftOperand() | isNullnessCompletionForParent = false)
  or
  exists(QualifiableExpr qe | qe.isConditional() |
    e = qe.getChildExpr(-1) and
    isNullnessCompletionForParent = false
  )
  or
  exists(ConditionalExpr ce | inNullnessContext(ce, _) |
    (e = ce.getThen() or e = ce.getElse()) and
    isNullnessCompletionForParent = true
  )
  or
  exists(NullCoalescingExpr nce | inNullnessContext(nce, _) |
    e = nce.getRightOperand() and
    isNullnessCompletionForParent = true
  )
  or
  exists(SwitchExpr se |
    inNullnessContext(se, _) and
    e = se.getACase().getBody() and
    isNullnessCompletionForParent = true
  )
}

/**
 * Holds if `pe` is the pattern inside case `c`, belonging to `switch` `s`, that
 * has the matching completion.
 */
predicate switchMatching(Switch s, Case c, PatternExpr pe) {
  s.getACase() = c and
  pe = c.getPattern()
}

private predicate mustHaveMatchingCompletion(Switch s, PatternExpr pe) { switchMatching(s, _, pe) }

/**
 * Holds if a normal completion of `cfe` must be a matching completion. Thats is,
 * whether `cfe` determines a match in a `switch` statement or `catch` clause.
 */
private predicate mustHaveMatchingCompletion(ControlFlowElement cfe) {
  mustHaveMatchingCompletion(_, cfe)
  or
  cfe instanceof SpecificCatchClause
}

/**
 * Holds if `cfe` is the element inside foreach statement `fs` that has the emptiness
 * completion.
 */
predicate foreachEmptiness(ForeachStmt fs, ControlFlowElement cfe) {
  cfe = fs // use `foreach` statement itself to represent the emptiness test
}

/**
 * Holds if a normal completion of `cfe` must be an emptiness completion. Thats is,
 * whether `cfe` determines whether to execute the body of a `foreach` statement.
 */
private predicate mustHaveEmptinessCompletion(ControlFlowElement cfe) { foreachEmptiness(_, cfe) }

/**
 * A completion that represents normal evaluation of a statement or an
 * expression.
 */
abstract class NormalCompletion extends Completion { }

/**
 * A class to make `TNormalCompletion` a `NormalCompletion`
 */
class SimpleCompletion extends NormalCompletion, TNormalCompletion {
  override string toString() { result = "normal" }
}

/**
 * A completion that represents evaluation of an expression, whose value determines
 * the successor. Either a Boolean completion (`BooleanCompletion`), a nullness
 * completion (`NullnessCompletion`), a matching completion (`MatchingCompletion`),
 * or an emptiness completion (`EmptinessCompletion`).
 */
abstract class ConditionalCompletion extends NormalCompletion { }

/**
 * A completion that represents evaluation of an expression
 * with a Boolean value.
 */
class BooleanCompletion extends ConditionalCompletion, TBooleanCompletion {
  /** Gets the value that the last sub expression of this expression completes with. */
  boolean getInnerValue() { this = TBooleanCompletion(_, result) }

  /** Gets the value that this expression completes with. */
  boolean getOuterValue() { this = TBooleanCompletion(result, _) }

  override string toString() { result = getOuterValue() + "/" + getInnerValue() }
}

/** A Boolean `true` completion. */
class TrueCompletion extends BooleanCompletion {
  TrueCompletion() { getOuterValue() = true }
}

/** A Boolean `false` completion. */
class FalseCompletion extends BooleanCompletion {
  FalseCompletion() { getOuterValue() = false }
}

/**
 * A completion that represents evaluation of an expression that is either
 * `null` or non-`null`.
 */
class NullnessCompletion extends ConditionalCompletion, TNullnessCompletion {
  /** Holds if the last sub expression of this expression evaluates to `null`. */
  predicate isNull() { this = TNullnessCompletion(true) }

  /** Holds if the last sub expression of this expression evaluates to a non-`null` value. */
  predicate isNonNull() { this = TNullnessCompletion(false) }

  override string toString() { if this.isNull() then result = "null" else result = "non-null" }
}

/**
 * A completion that represents matching, for example a `case` statement in a
 * `switch` statement.
 */
class MatchingCompletion extends ConditionalCompletion, TMatchingCompletion {
  /** Holds if there is a match. */
  predicate isMatch() { this = TMatchingCompletion(true) }

  /** Holds if there is not a match. */
  predicate isNonMatch() { this = TMatchingCompletion(false) }

  override string toString() { if this.isMatch() then result = "match" else result = "no-match" }
}

/**
 * A completion that represents evaluation of an emptiness test, for example
 * a test in a `foreach` statement.
 */
class EmptinessCompletion extends ConditionalCompletion, TEmptinessCompletion {
  /** Holds if the emptiness test evaluates to `true`. */
  predicate isEmpty() { this = TEmptinessCompletion(true) }

  override string toString() { if this.isEmpty() then result = "empty" else result = "non-empty" }
}

/**
 * A completion that represents evaluation of a statement or
 * expression resulting in a loop break.
 *
 * This completion is added for technical reasons only: when a loop
 * body can complete with a break completion, the loop itself completes
 * normally. However, if we choose `TNormalCompletion` as the completion
 * of the loop, we lose the information that the last element actually
 * completed with a break, meaning that the control flow edge out of the
 * breaking node cannot be marked with a `break` label.
 *
 * Example:
 *
 * ```
 * while (...) {
 *    ...
 *    break;
 * }
 * return;
 * ```
 *
 * The `break` on line 3 completes with a `TBreakCompletion`, therefore
 * the `while` loop can complete with a `TBreakNormalCompletion`, so we
 * get an edge `break --break--> return`. (If we instead used a
 * `TNormalCompletion`, we would get a less precise edge
 * `break --normal--> return`.)
 */
class BreakNormalCompletion extends NormalCompletion, TBreakNormalCompletion {
  override string toString() { result = "normal (break)" }
}

/**
 * A completion that represents abnormal evaluation of a statement or an
 * expression, for example exceptional flow.
 */
abstract class AbnormalCompletion extends Completion {
  /**
   * Gets the completion inherited by this completion, or the completion itself
   * when there is no inheritance.
   */
  InheritableCompletion getInheritedCompletion() { result = this }
}

/**
 * An abnormal completion that can be inherited by another control flow
 * element. For example, in
 *
 * ```
 * void M(bool b)
 * {
 *     try
 *     {
 *         if (b)
 *            throw new Exception();
 *     }
 *     finally
 *     {
 *         System.Console.WriteLine("M called");
 *     }
 * }
 * ```
 *
 * the throw completion for `Exception` can be inherited by the call
 * `System.Console.WriteLine("M called")`.
 */
abstract private class InheritableCompletion extends AbnormalCompletion { }

/**
 * An inherited completion. For example, in
 *
 * ```
 * void M(bool b)
 * {
 *     try
 *     {
 *         if (b)
 *            throw new Exception();
 *     }
 *     finally
 *     {
 *         System.Console.WriteLine("M called");
 *     }
 * }
 * ```
 *
 * `System.Console.WriteLine("M called")` inherits the throw completion
 * from `throw new Exception` with an underlying simple completion.
 */
class InheritedCompletion extends AbnormalCompletion, TInheritedCompletion {
  private NormalCompletion underlying;

  private InheritableCompletion inherited;

  InheritedCompletion() { this = TInheritedCompletion(underlying, inherited) }

  /** Gets the underlying completion. */
  NormalCompletion getUnderlyingCompletion() { result = underlying }

  override InheritableCompletion getInheritedCompletion() { result = inherited }

  override Completion getSourceCompletion() { result = underlying }

  override string toString() { result = inherited + " [" + underlying + "]" }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a return from a callable.
 */
abstract class ReturnCompletion extends AbnormalCompletion { }

private class ReturnCompletionDirect extends ReturnCompletion, InheritableCompletion,
  TReturnCompletion {
  override string toString() { result = "return" }
}

private class ReturnCompletionInherited extends ReturnCompletion, InheritedCompletion {
  ReturnCompletionInherited() { this = TInheritedCompletion(_, TReturnCompletion()) }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a break (in a loop or in a `switch`
 * statement).
 */
abstract class BreakCompletion extends AbnormalCompletion { }

private class BreakCompletionDirect extends BreakCompletion, InheritableCompletion, TBreakCompletion {
  override string toString() { result = "break" }
}

private class BreakCompletionInherited extends BreakCompletion, InheritedCompletion {
  BreakCompletionInherited() { this = TInheritedCompletion(_, TBreakCompletion()) }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a loop continuation (a `continue`
 * statement).
 */
abstract class ContinueCompletion extends AbnormalCompletion { }

private class ContinueCompletionDirect extends ContinueCompletion, InheritableCompletion,
  TContinueCompletion {
  override string toString() { result = "continue" }
}

private class ContinueCompletionInherited extends ContinueCompletion, InheritedCompletion {
  ContinueCompletionInherited() { this = TInheritedCompletion(_, TContinueCompletion()) }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a `goto` jump.
 */
abstract class GotoCompletion extends AbnormalCompletion { }

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a `goto label` jump.
 */
abstract class GotoLabelCompletion extends GotoCompletion {
  /** Gets the target of the `goto label` completion. */
  string getLabel() { result = this.getGotoStmt().getLabel() }

  /** Gets the statement that resulted in this `goto label` completion. */
  abstract GotoLabelStmt getGotoStmt();
}

private class GotoLabelCompletionDirect extends GotoLabelCompletion, InheritableCompletion,
  TGotoLabelCompletion {
  override GotoLabelStmt getGotoStmt() { this = TGotoLabelCompletion(result) }

  override string toString() { result = "goto(" + getLabel() + ")" }
}

private class GotoLabelCompletionInherited extends GotoLabelCompletion, InheritedCompletion {
  private TGotoLabelCompletion inherited;

  GotoLabelCompletionInherited() { this = TInheritedCompletion(_, inherited) }

  override GotoLabelStmt getGotoStmt() { inherited = TGotoLabelCompletion(result) }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a `goto case` jump.
 */
abstract class GotoCaseCompletion extends GotoCompletion {
  /** Gets the target of the `goto case` completion. */
  string getLabel() { result = this.getGotoStmt().getLabel() }

  /** Gets the statement that resulted in this `goto case` completion. */
  abstract GotoCaseStmt getGotoStmt();
}

private class GotoCaseCompletionDirect extends GotoCaseCompletion, InheritableCompletion,
  TGotoCaseCompletion {
  override GotoCaseStmt getGotoStmt() { this = TGotoCaseCompletion(result) }

  override string toString() { result = "goto case(" + getGotoStmt().getLabel() + ")" }
}

private class GotoCaseCompletionInherited extends GotoCaseCompletion, InheritedCompletion {
  private TGotoCaseCompletion inherited;

  GotoCaseCompletionInherited() { this = TInheritedCompletion(_, inherited) }

  override GotoCaseStmt getGotoStmt() { inherited = TGotoCaseCompletion(result) }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a `goto default` jump.
 */
abstract class GotoDefaultCompletion extends GotoCompletion { }

private class GotoDefaultCompletionDirect extends GotoDefaultCompletion, InheritableCompletion,
  TGotoDefaultCompletion {
  override string toString() { result = "goto default" }
}

private class GotoDefaultCompletionInherited extends GotoDefaultCompletion, InheritedCompletion {
  GotoDefaultCompletionInherited() { this = TInheritedCompletion(_, TGotoDefaultCompletion()) }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a thrown exception.
 */
abstract class ThrowCompletion extends AbnormalCompletion {
  /** Gets the type of the exception being thrown. */
  abstract ExceptionClass getExceptionClass();
}

class ThrowCompletionDirect extends ThrowCompletion, InheritableCompletion, TThrowCompletion {
  override ExceptionClass getExceptionClass() { this = TThrowCompletion(result) }

  override string toString() { result = "throw(" + this.getExceptionClass() + ")" }
}

private class ThrowCompletionInherited extends ThrowCompletion, InheritedCompletion {
  private TThrowCompletion inherited;

  ThrowCompletionInherited() { this = TInheritedCompletion(_, inherited) }

  override ExceptionClass getExceptionClass() { inherited = TThrowCompletion(result) }
}

/**
 * A completion that represents evaluation of a statement or an
 * expression resulting in a program exit, for example
 * `System.Environment.Exit(0)`.
 *
 * An exit completion is different from a `return` completion; the former
 * exits the whole application, and exists inside `try` statements skip
 * `finally` blocks.
 */
abstract class ExitCompletion extends AbnormalCompletion { }

class ExitCompletionDirect extends ExitCompletion, InheritableCompletion, TExitCompletion {
  override string toString() { result = "exit" }
}

private class ExitCompletionInherited extends ExitCompletion, InheritedCompletion {
  ExitCompletionInherited() { this = TInheritedCompletion(_, TExitCompletion()) }
}
