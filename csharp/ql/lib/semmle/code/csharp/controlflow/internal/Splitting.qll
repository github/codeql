/**
 * INTERNAL: Do not use.
 *
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

import csharp
private import Completion as Comp
private import Comp
private import ControlFlowGraphImpl
private import semmle.code.csharp.controlflow.ControlFlowGraph::ControlFlow as Cfg
private import semmle.code.csharp.controlflow.internal.PreSsa

cached
private module Cached {
  private import semmle.code.csharp.Caching

  cached
  newtype TBooleanSplitSubKind =
    TSsaBooleanSplitSubKind(PreSsa::Definition def) {
      Stages::ControlFlowStage::forceCachingInSameStage()
    }

  cached
  newtype TSplitKind =
    TInitializerSplitKind() or
    TConditionalCompletionSplitKind() or
    TAssertionSplitKind() or
    TExceptionHandlerSplitKind()

  cached
  newtype TSplit =
    TInitializerSplit(Constructor c) { InitializerSplitting::constructorInitializes(c, _) } or
    TConditionalCompletionSplit(ConditionalCompletion c) or
    TAssertionSplit(AssertionSplitting::Assertion a, int i, boolean success) {
      exists(a.getExpr(i)) and
      success in [false, true]
    } or
    TExceptionHandlerSplit(ExceptionClass ec)
}

import Cached

/**
 * A split for a control flow element. For example, a tag that determines how to
 * continue execution after leaving a `finally` block.
 */
class Split extends TSplit {
  /** Gets a textual representation of this split. */
  string toString() { none() }
}

module InitializerSplitting {
  private import semmle.code.csharp.ExprOrStmtParent

  /**
   * A non-static member with an initializer, for example a field `int Field = 0`.
   */
  class InitializedInstanceMember extends Member {
    InitializedInstanceMember() {
      exists(AssignExpr ae |
        not this.isStatic() and
        expr_parent_top_level(ae, _, this) and
        not ae = any(Callable c).getExpressionBody()
      )
    }

    /** Gets the initializer expression. */
    AssignExpr getInitializer() { expr_parent_top_level(result, _, this) }

    /**
     * Gets a control flow element that is a syntactic descendant of the
     * initializer expression.
     */
    AstNode getAnInitializerDescendant() {
      result = this.getInitializer()
      or
      result = this.getAnInitializerDescendant().getAChild()
    }
  }

  /**
   * Holds if `c` is a non-static constructor that performs the initialization
   * of a member via assignment `init`.
   */
  predicate constructorInitializes(InstanceConstructor c, AssignExpr init) {
    exists(InitializedInstanceMember m |
      c.isUnboundDeclaration() and
      c.getDeclaringType().getAMember() = m and
      not c.getInitializer().isThis() and
      init = m.getInitializer()
    )
  }

  /**
   * Gets the `i`th member initializer expression for non-static constructor `c`
   * in compilation `comp`.
   */
  AssignExpr constructorInitializeOrder(Constructor c, CompilationExt comp, int i) {
    constructorInitializes(c, result) and
    result =
      rank[i + 1](AssignExpr ae0, Location l |
        constructorInitializes(c, ae0) and
        l = ae0.getLocation() and
        getCompilation(l.getFile()) = comp
      |
        ae0 order by l.getStartLine(), l.getStartColumn(), l.getFile().getAbsolutePath()
      )
  }

  /**
   * Gets the last member initializer expression for non-static constructor `c`
   * in compilation `comp`.
   */
  AssignExpr lastConstructorInitializer(Constructor c, CompilationExt comp) {
    exists(int i |
      result = constructorInitializeOrder(c, comp, i) and
      not exists(constructorInitializeOrder(c, comp, i + 1))
    )
  }

  /**
   * A split for non-static member initializers belonging to a given non-static
   * constructor. For example, in
   *
   * ```csharp
   * class C
   * {
   *     int Field1 = 0;
   *     int Field2 = Field1 + 1;
   *     int Field3;
   *
   *     public C()
   *     {
   *         Field3 = 2;
   *     }
   *
   *     public C(int i)
   *     {
   *         Field3 = 3;
   *     }
   * }
   * ```
   *
   * the initializer expressions `Field1 = 0` and `Field2 = Field1 + 1` are split
   * on the two constructors. This is in order to generate CFGs for the two
   * constructors that mimic
   *
   * ```csharp
   * public C()
   * {
   *     Field1 = 0;
   *     Field2 = Field1 + 1;
   *     Field3 = 2;
   * }
   * ```
   *
   * and
   *
   * ```csharp
   * public C()
   * {
   *     Field1 = 0;
   *     Field2 = Field1 + 1;
   *     Field3 = 3;
   * }
   * ```
   *
   * respectively.
   */
  private class InitializerSplit extends Split, TInitializerSplit {
    private Constructor c;

    InitializerSplit() { this = TInitializerSplit(c) }

    /** Gets the constructor. */
    Constructor getConstructor() { result = c }

    override string toString() { result = "" }
  }

  private class InitializerSplitKind extends SplitKind, TInitializerSplitKind {
    override int getListOrder() { result = 0 }

    override predicate isEnabled(AstNode cfe) { this.appliesTo(cfe) }

    override string toString() { result = "Initializer" }
  }

  int getNextListOrder() { result = 1 }

  private class InitializerSplitImpl extends SplitImpl instanceof InitializerSplit {
    override InitializerSplitKind getKind() { any() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      exists(ConstructorInitializer ci |
        last(ci, pred, c) and
        succ(pred, succ, c) and
        succ = any(InitializedInstanceMember m).getAnInitializerDescendant() and
        super.getConstructor() = ci.getConstructor()
      )
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) {
      scopeFirst(scope, first) and
      scope = super.getConstructor() and
      first = any(InitializedInstanceMember m).getAnInitializerDescendant()
    }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      this.appliesTo(pred) and
      succ(pred, succ, c) and
      not succ = any(InitializedInstanceMember m).getAnInitializerDescendant() and
      succ.(ControlFlowElement).getEnclosingCallable() = super.getConstructor()
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      this.appliesTo(last) and
      scopeLast(scope, last, c) and
      scope = super.getConstructor()
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesSucc(pred, succ, c) and
      succ =
        any(InitializedInstanceMember m |
          constructorInitializes(super.getConstructor(), m.getInitializer())
        ).getAnInitializerDescendant()
    }
  }
}

module ConditionalCompletionSplitting {
  /**
   * A split for conditional completions. For example, in
   *
   * ```csharp
   * void M(int i)
   * {
   *     if (x && !y)
   *         System.Console.WriteLine("true")
   * }
   * ```
   *
   * we record whether `x`, `y`, and `!y` evaluate to `true` or `false`, and restrict
   * the edges out of `!y` and `x && !y` accordingly.
   */
  class ConditionalCompletionSplit extends Split, TConditionalCompletionSplit {
    ConditionalCompletion completion;

    ConditionalCompletionSplit() { this = TConditionalCompletionSplit(completion) }

    ConditionalCompletion getCompletion() { result = completion }

    override string toString() { result = completion.toString() }
  }

  private class ConditionalCompletionSplitKind_ extends SplitKind, TConditionalCompletionSplitKind {
    override int getListOrder() { result = InitializerSplitting::getNextListOrder() }

    override predicate isEnabled(AstNode cfe) { this.appliesTo(cfe) }

    override string toString() { result = "ConditionalCompletion" }
  }

  module ConditionalCompletionSplittingInput {
    private import Completion as Comp

    class ConditionalCompletion = Comp::ConditionalCompletion;

    class ConditionalCompletionSplitKind extends ConditionalCompletionSplitKind_, TSplitKind { }

    class ConditionalCompletionSplit = ConditionalCompletionSplitting::ConditionalCompletionSplit;

    bindingset[parent, parentCompletion]
    predicate condPropagateExpr(
      AstNode parent, ConditionalCompletion parentCompletion, AstNode child,
      ConditionalCompletion childCompletion
    ) {
      child = parent.(LogicalNotExpr).getOperand() and
      childCompletion.getDual() = parentCompletion
      or
      childCompletion = parentCompletion and
      (
        child = parent.(LogicalAndExpr).getAnOperand()
        or
        child = parent.(LogicalOrExpr).getAnOperand()
        or
        parent = any(ConditionalExpr ce | child = [ce.getThen(), ce.getElse()])
        or
        child = parent.(SwitchExpr).getACase()
        or
        child = parent.(SwitchCaseExpr).getBody()
        or
        parent =
          any(NullCoalescingExpr nce |
            if childCompletion instanceof NullnessCompletion
            then child = nce.getRightOperand()
            else child = nce.getAnOperand()
          )
      )
      or
      child = parent.(NotPatternExpr).getPattern() and
      childCompletion.getDual() = parentCompletion
      or
      child = parent.(IsExpr).getPattern() and
      parentCompletion.(BooleanCompletion).getValue() =
        childCompletion.(MatchingCompletion).getValue()
      or
      childCompletion = parentCompletion and
      (
        child = parent.(AndPatternExpr).getAnOperand()
        or
        child = parent.(OrPatternExpr).getAnOperand()
        or
        child = parent.(RecursivePatternExpr).getAChildExpr()
        or
        child = parent.(PropertyPatternExpr).getPattern(_)
      )
    }
  }

  int getNextListOrder() { result = InitializerSplitting::getNextListOrder() + 1 }
}

module AssertionSplitting {
  import semmle.code.csharp.commons.Assertions
  private import semmle.code.csharp.ExprOrStmtParent

  private AstNode getAnAssertionDescendant(Assertion a) {
    result = a
    or
    result = getAnAssertionDescendant(a).getAChild()
  }

  /**
   * A split for assertions. For example, in
   *
   * ```csharp
   * void M(int i)
   * {
   *     Debug.Assert(i >= 0);
   *     System.Console.WriteLine("i is positive")
   * }
   * ```
   *
   * we record whether `i >= 0` evaluates to `true` or `false`, and restrict the
   * edges out of the assertion accordingly.
   */
  class AssertionSplit extends Split, TAssertionSplit {
    Assertion a;
    boolean success;
    int i;

    AssertionSplit() { this = TAssertionSplit(a, i, success) }

    /** Gets the assertion. */
    Assertion getAssertion() { result = a }

    /** Holds if this split represents a successful assertion. */
    predicate isSuccess() { success = true }

    override string toString() {
      success = true and result = "assertion success"
      or
      success = false and result = "assertion failure"
    }
  }

  private class AssertionSplitKind extends SplitKind, TAssertionSplitKind {
    override int getListOrder() { result = ConditionalCompletionSplitting::getNextListOrder() }

    override predicate isEnabled(AstNode cfe) { this.appliesTo(cfe) }

    override string toString() { result = "Assertion" }
  }

  int getNextListOrder() { result = ConditionalCompletionSplitting::getNextListOrder() + 1 }

  private class AssertionSplitImpl extends SplitImpl instanceof AssertionSplit {
    Assertion a;
    boolean success;
    int i;

    AssertionSplitImpl() { this = TAssertionSplit(a, i, success) }

    override AssertionSplitKind getKind() { any() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      exists(AssertMethod m |
        last(a.getExpr(i), pred, c) and
        succ(pred, succ, c) and
        m = a.getAssertMethod() and
        // The assertion only succeeds when all asserted arguments succeeded, so
        // we only enter a "success" state after the last argument has succeeded.
        //
        // The split is only entered if we are not already in a "failing" state
        // for one of the previous arguments, which ensures that the "success"
        // state is only entered when all arguments succeed. This also means
        // that if multiple arguments fail, then the first failing argument
        // will determine the exception being thrown by the assertion.
        if success = true then i = max(int j | exists(a.getExpr(j))) else any()
      |
        exists(boolean b | i = m.(BooleanAssertMethod).getAnAssertionIndex(b) |
          c instanceof TrueCompletion and success = b
          or
          c instanceof FalseCompletion and success = b.booleanNot()
        )
        or
        exists(boolean b | i = m.(NullnessAssertMethod).getAnAssertionIndex(b) |
          c.(NullnessCompletion).isNull() and success = b
          or
          c.(NullnessCompletion).isNonNull() and success = b.booleanNot()
        )
      )
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) { none() }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      this.appliesTo(pred) and
      pred = a and
      succ(pred, succ, c) and
      (
        success = true and
        c instanceof NormalCompletion
        or
        success = false and
        c = assertionCompletion(a, i)
      )
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      this.appliesTo(last) and
      last = a and
      scopeLast(scope, last, c) and
      (
        success = true and
        c instanceof NormalCompletion
        or
        success = false and
        c = assertionCompletion(a, i)
      )
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesSucc(pred, succ, c) and
      succ = getAnAssertionDescendant(a)
    }
  }
}

module ExceptionHandlerSplitting {
  private newtype TMatch =
    TAlways() or
    TMaybe() or
    TNever()

  /**
   * A split for elements belonging to a `catch` clause, which determines the type of
   * exception to handle. For example, in
   *
   * ```csharp
   * try
   * {
   *     if (M() > 0)
   *         throw new ArgumentException();
   *     else if (M() < 0)
   *         throw new ArithmeticException("negative");
   *     else
   *         return;
   * }
   * catch (ArgumentException e)
   * {
   *     Log.Write("M() positive");
   * }
   * catch (ArithmeticException e) when (e.Message != null)
   * {
   *     Log.Write($"M() {e.Message}");
   * }
   * ```
   *
   * all control flow nodes in
   * ```csharp
   * catch (ArgumentException e)
   * ```
   * and
   * ```csharp
   * catch (ArithmeticException e) when (e.Message != null)
   * ```
   * have two splits: one representing the `try` block throwing an `ArgumentException`,
   * and one representing the `try` block throwing an `ArithmeticException`.
   */
  class ExceptionHandlerSplit extends Split, TExceptionHandlerSplit {
    private ExceptionClass ec;

    ExceptionHandlerSplit() { this = TExceptionHandlerSplit(ec) }

    /** Gets the exception type that this split represents. */
    ExceptionClass getExceptionClass() { result = ec }

    override string toString() { result = "exception: " + ec.toString() }
  }

  private class ExceptionHandlerSplitKind extends SplitKind, TExceptionHandlerSplitKind {
    override int getListOrder() { result = AssertionSplitting::getNextListOrder() }

    override string toString() { result = "ExceptionHandler" }
  }

  int getNextListOrder() { result = AssertionSplitting::getNextListOrder() + 1 }

  private class ExceptionHandlerSplitImpl extends SplitImpl instanceof ExceptionHandlerSplit {
    override ExceptionHandlerSplitKind getKind() { any() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      // Entry into first catch clause
      exists(Statements::TryStmtTree ts |
        super.getExceptionClass() = ts.getAThrownException(pred, c)
      |
        succ(pred, succ, c) and
        succ = ts.(TryStmt).getCatchClause(0).(SpecificCatchClause)
      )
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) { none() }

    /**
     * Holds if this split applies to catch clause `scc`. The parameter `match`
     * indicates whether the catch clause `scc` may match the exception type of
     * this split.
     */
    private predicate appliesToCatchClause(SpecificCatchClause scc, TMatch match) {
      exists(Statements::TryStmtTree ts, ExceptionClass ec |
        ec = super.getExceptionClass() and
        ec = ts.getAThrownException(_, _) and
        scc = ts.(TryStmt).getACatchClause()
      |
        if scc.getCaughtExceptionType() = ec.getABaseType*()
        then match = TAlways()
        else
          if scc.getCaughtExceptionType() = ec.getASubType+()
          then match = TMaybe()
          else match = TNever()
      )
    }

    /**
     * Holds if this split applies to control flow element `pred`, where `pred`
     * is a valid predecessor with completion `c`.
     */
    private predicate appliesToPredecessor(AstNode pred, Completion c) {
      this.appliesTo(pred) and
      (succ(pred, _, c) or scopeLast(_, pred, c)) and
      (
        pred instanceof SpecificCatchClause
        implies
        pred =
          any(SpecificCatchClause scc |
            if c instanceof MatchingCompletion
            then
              exists(TMatch match | this.appliesToCatchClause(scc, match) |
                c =
                  any(MatchingCompletion mc |
                    if mc.isMatch() then match != TNever() else match != TAlways()
                  )
              )
            else (
              (scc.isLast() and c instanceof ThrowCompletion)
              implies
              exists(TMatch match | this.appliesToCatchClause(scc, match) | match != TAlways())
            )
          )
      )
    }

    /**
     * Holds if this split applies to `pred`, and `pred` may exit this split
     * with throw completion `c`, because it belongs to the last `catch` clause
     * in a `try` statement.
     */
    private predicate hasLastExit(AstNode pred, ThrowCompletion c) {
      this.appliesToPredecessor(pred, c) and
      exists(TryStmt ts, SpecificCatchClause scc, int last |
        last(ts.getCatchClause(last), pred, c)
      |
        ts.getCatchClause(last) = scc and
        scc.isLast() and
        c.getExceptionClass() = super.getExceptionClass()
      )
    }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      this.appliesToPredecessor(pred, c) and
      succ(pred, succ, c) and
      (
        // Exit out to `catch` clause block
        first(any(SpecificCatchClause scc).getBlock(), succ)
        or
        // Exit out to a general `catch` clause
        succ instanceof GeneralCatchClause
        or
        // Exit out from last `catch` clause (no catch clauses match)
        this.hasLastExit(pred, c)
      )
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      // Exit out from last `catch` clause (no catch clauses match)
      this.hasLastExit(last, c) and
      scopeLast(scope, last, c)
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesToPredecessor(pred, c) and
      this.appliesSucc(pred, succ, c) and
      not first(any(SpecificCatchClause scc).getBlock(), succ) and
      not succ instanceof GeneralCatchClause and
      not exists(TryStmt ts, SpecificCatchClause scc, int last |
        last(ts.getCatchClause(last), pred, c)
      |
        ts.getCatchClause(last) = scc and
        scc.isLast()
      )
    }
  }
}
