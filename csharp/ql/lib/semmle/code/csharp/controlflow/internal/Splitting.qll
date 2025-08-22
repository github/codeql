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
    TFinallySplitKind(int nestLevel) { nestLevel = any(Statements::TryStmtTree t).nestLevel() } or
    TExceptionHandlerSplitKind() or
    TBooleanSplitKind(BooleanSplitting::BooleanSplitSubKind kind) { kind.startsSplit(_) } or
    TLoopSplitKind(LoopSplitting::AnalyzableLoopStmt loop)

  cached
  newtype TSplit =
    TInitializerSplit(Constructor c) { InitializerSplitting::constructorInitializes(c, _) } or
    TConditionalCompletionSplit(ConditionalCompletion c) or
    TAssertionSplit(AssertionSplitting::Assertion a, int i, boolean success) {
      exists(a.getExpr(i)) and
      success in [false, true]
    } or
    TFinallySplit(FinallySplitting::FinallySplitType type, int nestLevel) {
      nestLevel = any(Statements::TryStmtTree t).nestLevel()
    } or
    TExceptionHandlerSplit(ExceptionClass ec) or
    TBooleanSplit(BooleanSplitting::BooleanSplitSubKind kind, boolean branch) {
      kind.startsSplit(_) and
      branch in [false, true]
    } or
    TLoopSplit(LoopSplitting::AnalyzableLoopStmt loop)
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

module FinallySplitting {
  /**
   * The type of a split `finally` node.
   *
   * The type represents one of the possible ways of entering a `finally`
   * block. For example, if a `try` statement ends with a `return` statement,
   * then the `finally` block must end with a `return` as well (provided that
   * the `finally` block exits normally).
   */
  class FinallySplitType extends Cfg::SuccessorType {
    FinallySplitType() { not this instanceof Cfg::SuccessorTypes::ConditionalSuccessor }

    /** Holds if this split type matches entry into a `finally` block with completion `c`. */
    predicate isSplitForEntryCompletion(Completion c) {
      if c instanceof NormalCompletion
      then
        // If the entry into the `finally` block completes with any normal completion,
        // it simply means normal execution after the `finally` block
        this instanceof Cfg::SuccessorTypes::NormalSuccessor
      else this = c.getAMatchingSuccessorType()
    }
  }

  /** A control flow element that belongs to a `finally` block. */
  private class FinallyAstNode extends AstNode {
    private Statements::TryStmtTree try;

    FinallyAstNode() { this = try.getAFinallyDescendant() }

    /** Gets the immediate `try` block that this node belongs to. */
    Statements::TryStmtTree getTryStmt() { result = try }

    /** Holds if this node is the entry node in the `finally` block it belongs to. */
    predicate isEntryNode() { first(try.(TryStmt).getFinally(), this) }
  }

  /**
   * A split for elements belonging to a `finally` block, which determines how to
   * continue execution after leaving the `finally` block. For example, in
   *
   * ```csharp
   * try
   * {
   *     if (!M())
   *         throw new Exception();
   * }
   * finally
   * {
   *     Log.Write("M failed");
   * }
   * ```
   *
   * all control flow nodes in the `finally` block have two splits: one representing
   * normal execution of the `try` block (when `M()` returns `true`), and one
   * representing exceptional execution of the `try` block (when `M()` returns `false`).
   */
  class FinallySplit extends Split, TFinallySplit {
    private FinallySplitType type;
    private int nestLevel;

    FinallySplit() { this = TFinallySplit(type, nestLevel) }

    /**
     * Gets the type of this `finally` split, that is, how to continue execution after the
     * `finally` block.
     */
    FinallySplitType getType() { result = type }

    /** Gets the `finally` nesting level. */
    int getNestLevel() { result = nestLevel }

    override string toString() {
      if type instanceof Cfg::SuccessorTypes::NormalSuccessor
      then result = ""
      else
        if nestLevel > 0
        then result = "finally(" + nestLevel + "): " + type.toString()
        else result = "finally: " + type.toString()
    }
  }

  private int getListOrder(FinallySplitKind kind) {
    result = AssertionSplitting::getNextListOrder() + kind.getNestLevel()
  }

  int getNextListOrder() {
    result = max([getListOrder(_) + 1, AssertionSplitting::getNextListOrder()])
  }

  private class FinallySplitKind extends SplitKind, TFinallySplitKind {
    private int nestLevel;

    FinallySplitKind() { this = TFinallySplitKind(nestLevel) }

    /** Gets the `finally` nesting level. */
    int getNestLevel() { result = nestLevel }

    override int getListOrder() { result = getListOrder(this) }

    override string toString() { result = "Finally (" + nestLevel + ")" }
  }

  pragma[nomagic]
  private predicate hasEntry0(AstNode pred, FinallyAstNode succ, int nestLevel, Completion c) {
    succ.isEntryNode() and
    nestLevel = succ.getTryStmt().nestLevel() and
    succ(pred, succ, c)
  }

  private class FinallySplitImpl extends SplitImpl instanceof FinallySplit {
    override FinallySplitKind getKind() { result.getNestLevel() = super.getNestLevel() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      hasEntry0(pred, succ, super.getNestLevel(), c) and
      super.getType().isSplitForEntryCompletion(c)
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) { none() }

    /**
     * Holds if this split applies to control flow element `pred`, where `pred`
     * is a valid predecessor.
     */
    private predicate appliesToPredecessor(AstNode pred) {
      this.appliesTo(pred) and
      (succ(pred, _, _) or scopeLast(_, pred, _))
    }

    pragma[noinline]
    private predicate exit0(AstNode pred, Statements::TryStmtTree try, int nestLevel, Completion c) {
      this.appliesToPredecessor(pred) and
      nestLevel = try.nestLevel() and
      last(try, pred, c)
    }

    /**
     * Holds if `pred` may exit this split with completion `c`. The Boolean
     * `inherited` indicates whether `c` is an inherited completion from a `try`/
     * `catch` block.
     */
    private predicate exit(AstNode pred, Completion c, boolean inherited) {
      exists(TryStmt try, FinallySplitType type |
        this.exit0(pred, try, super.getNestLevel(), c) and
        type = super.getType()
      |
        if last(try.getFinally(), pred, c)
        then
          // Finally block can itself exit with completion `c`: either `c` must
          // match this split, `c` must be an abnormal completion, or this split
          // does not require another completion to be recovered
          inherited = false and
          (
            type = c.getAMatchingSuccessorType()
            or
            not c instanceof NormalCompletion
            or
            type instanceof Cfg::SuccessorTypes::NormalSuccessor
          )
        else (
          // Finally block can exit with completion `c` inherited from try/catch
          // block: must match this split
          inherited = true and
          type = c.getAMatchingSuccessorType() and
          not type instanceof Cfg::SuccessorTypes::NormalSuccessor
        )
      )
      or
      // If this split is normal, and an outer split can exit based on an inherited
      // completion, we need to exit this split as well. For example, in
      //
      // ```csharp
      // bool done;
      // try
      // {
      //     if (b1) throw new ExceptionA();
      // }
      // finally
      // {
      //     try
      //     {
      //         if (b2) throw new ExceptionB();
      //     }
      //     finally
      //     {
      //         done = true;
      //     }
      // }
      // ```
      //
      // if the outer split for `done = true` is `ExceptionA` and the inner split
      // is "normal" (corresponding to `b1 = true` and `b2 = false`), then the inner
      // split must be able to exit with an `ExceptionA` completion.
      this.appliesToPredecessor(pred) and
      exists(FinallySplit outer |
        outer.getNestLevel() = super.getNestLevel() - 1 and
        outer.(FinallySplitImpl).exit(pred, c, inherited) and
        super.getType() instanceof Cfg::SuccessorTypes::NormalSuccessor and
        inherited = true
      )
    }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      succ(pred, succ, c) and
      (
        this.exit(pred, c, _)
        or
        this.exit(pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion(), _)
      )
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      scopeLast(scope, last, c) and
      (
        this.exit(last, c, _)
        or
        this.exit(last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion(), _)
      )
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesSucc(pred, succ, c) and
      succ =
        any(FinallyAstNode fcfe |
          if fcfe.isEntryNode()
          then
            // entering a nested `finally` block
            fcfe.getTryStmt().nestLevel() > super.getNestLevel()
          else
            // staying in the same (possibly nested) `finally` block as `pred`
            fcfe.getTryStmt().nestLevel() >= super.getNestLevel()
        )
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
    override int getListOrder() { result = FinallySplitting::getNextListOrder() }

    override string toString() { result = "ExceptionHandler" }
  }

  int getNextListOrder() { result = FinallySplitting::getNextListOrder() + 1 }

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

module BooleanSplitting {
  private import semmle.code.csharp.controlflow.internal.PreBasicBlocks

  /** A sub-classification of Boolean splits. */
  abstract class BooleanSplitSubKind extends TBooleanSplitSubKind {
    /**
     * Holds if the branch taken by condition `cb1` should be recorded in
     * this split, and the recorded value determines the branch taken by a
     * later condition `cb2`, possibly inverted.
     *
     * For example, in
     *
     * ```csharp
     * var b = GetB();
     * if (b)
     *     Console.WriteLine("b is true");
     * if (!b)
     *     Console.WriteLine("b is false");
     * ```
     *
     * the branch taken in the condition on line 2 can be recorded, and the
     * recorded value will determine the branch taken in the condition on line 4.
     */
    abstract predicate correlatesConditions(ConditionBlock cb1, ConditionBlock cb2, boolean inverted);

    /** Holds if control flow element `cfe` starts a split of this kind. */
    predicate startsSplit(AstNode cfe) {
      this.correlatesConditions(any(ConditionBlock cb | cb.getLastElement() = cfe), _, _)
    }

    /**
     * Holds if basic block `bb` can reach a condition correlated with a
     * split of this kind.
     */
    abstract predicate canReachCorrelatedCondition(PreBasicBlock bb);

    /** Gets the callable that this Boolean split kind belongs to. */
    abstract Callable getEnclosingCallable();

    /** Gets a textual representation of this Boolean split kind. */
    abstract string toString();

    /** Gets the location of this Boolean split kind. */
    abstract Location getLocation();
  }

  /**
   * A Boolean split that records the value of a Boolean SSA variable.
   *
   * For example, in
   *
   * ```csharp
   * var b = GetB();
   * if (b)
   *     Console.WriteLine("b is true");
   * if (!b)
   *     Console.WriteLine("b is false");
   * ```
   *
   * there is a Boolean split on the SSA variable for `b` at line 1.
   */
  class SsaBooleanSplitSubKind extends BooleanSplitSubKind, TSsaBooleanSplitSubKind {
    private PreSsa::Definition def;

    SsaBooleanSplitSubKind() { this = TSsaBooleanSplitSubKind(def) }

    /**
     * Holds if condition `cb` is a read of the SSA variable in this split.
     */
    private predicate defCondition(ConditionBlock cb) { cb.getLastElement() = def.getARead() }

    /**
     * Holds if condition `cb` is a read of the SSA variable in this split,
     * and `cb` can be reached from `read` without passing through another
     * condition that reads the same SSA variable.
     */
    private predicate defConditionReachableFromRead(ConditionBlock cb, AssignableRead read) {
      this.defCondition(cb) and
      read = cb.getLastElement()
      or
      exists(AssignableRead mid | this.defConditionReachableFromRead(cb, mid) |
        PreSsa::adjacentReadPairSameVar(read, mid) and
        not this.defCondition(read)
      )
    }

    /**
     * Holds if condition `cb` is a read of the SSA variable in this split,
     * and `cb` can be reached from the SSA definition without passing through
     * another condition that reads the same SSA variable.
     */
    private predicate firstDefCondition(ConditionBlock cb) {
      this.defConditionReachableFromRead(cb, def.getAFirstRead())
    }

    override predicate correlatesConditions(ConditionBlock cb1, ConditionBlock cb2, boolean inverted) {
      this.firstDefCondition(cb1) and
      exists(AssignableRead read1, AssignableRead read2 |
        read1 = cb1.getLastElement() and
        PreSsa::adjacentReadPairSameVar+(read1, read2) and
        read2 = cb2.getLastElement() and
        inverted = false
      )
    }

    override predicate canReachCorrelatedCondition(PreBasicBlock bb) {
      this.correlatesConditions(_, bb, _) and
      not def.getBasicBlock() = bb
      or
      exists(PreBasicBlock mid | this.canReachCorrelatedCondition(mid) |
        bb = mid.getAPredecessor() and
        not def.getBasicBlock() = bb
      )
    }

    override Callable getEnclosingCallable() { result = def.getBasicBlock().getEnclosingCallable() }

    override string toString() { result = def.getSourceVariable().toString() }

    override Location getLocation() { result = def.getLocation() }
  }

  /**
   * A split for elements that can reach a condition where this split determines
   * the Boolean value that the condition evaluates to. For example, in
   *
   * ```csharp
   * if (b)
   *     Console.WriteLine("b is true");
   * if (!b)
   *     Console.WriteLine("b is false");
   * ```
   *
   * all control flow nodes on line 2 and line 3 have two splits: one representing
   * that the condition on line 1 took the `true` branch, and one representing that
   * the condition on line 1 took the `false` branch.
   */
  class BooleanSplit extends Split, TBooleanSplit {
    private BooleanSplitSubKind kind;
    private boolean branch;

    BooleanSplit() { this = TBooleanSplit(kind, branch) }

    /** Gets the kind of this Boolean split. */
    BooleanSplitSubKind getSubKind() { result = kind }

    /** Gets the branch taken in this split. */
    boolean getBranch() { result = branch }

    override string toString() {
      exists(int line |
        line = kind.getLocation().getStartLine() and
        result = kind.toString() + " (line " + line + "): " + branch.toString()
      )
    }
  }

  private int getListOrder(BooleanSplitSubKind kind) {
    exists(Callable c, int r | c = kind.getEnclosingCallable() |
      result = r + ExceptionHandlerSplitting::getNextListOrder() - 1 and
      kind =
        rank[r](BooleanSplitSubKind kind0, Location l |
          kind0.getEnclosingCallable() = c and
          kind0.startsSplit(_) and
          l = kind0.getLocation()
        |
          kind0 order by l.getStartLine(), l.getStartColumn(), kind0.toString()
        )
    )
  }

  int getNextListOrder() {
    result = max([getListOrder(_) + 1, ExceptionHandlerSplitting::getNextListOrder()])
  }

  private class BooleanSplitKind extends SplitKind, TBooleanSplitKind {
    private BooleanSplitSubKind kind;

    BooleanSplitKind() { this = TBooleanSplitKind(kind) }

    /** Gets the sub kind of this Boolean split kind. */
    BooleanSplitSubKind getSubKind() { result = kind }

    override int getListOrder() { result = getListOrder(kind) }

    override string toString() { result = kind.toString() }
  }

  pragma[nomagic]
  private predicate hasEntry0(
    AstNode pred, AstNode succ, BooleanSplitSubKind kind, boolean b, Completion c
  ) {
    kind.startsSplit(pred) and
    succ(pred, succ, c) and
    b = c.getInnerCompletion().(BooleanCompletion).getValue()
  }

  private class BooleanSplitImpl extends SplitImpl instanceof BooleanSplit {
    override BooleanSplitKind getKind() { result.getSubKind() = super.getSubKind() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      hasEntry0(pred, succ, super.getSubKind(), super.getBranch(), c)
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) { none() }

    private ConditionBlock getACorrelatedCondition(boolean inverted) {
      super.getSubKind().correlatesConditions(_, result, inverted)
    }

    /**
     * Holds if this split applies to basic block `bb`, where the the last
     * element of `bb` can have completion `c`.
     */
    private predicate appliesToBlock(PreBasicBlock bb, Completion c) {
      this.appliesTo(bb) and
      exists(AstNode last | last = bb.getLastElement() |
        (succ(last, _, c) or scopeLast(_, last, c)) and
        // Respect the value recorded in this split for all correlated conditions
        forall(boolean inverted | bb = this.getACorrelatedCondition(inverted) |
          c.getInnerCompletion() instanceof BooleanCompletion
          implies
          c.getInnerCompletion().(BooleanCompletion).getValue() =
            super.getBranch().booleanXor(inverted)
        )
      )
    }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      exists(PreBasicBlock bb | this.appliesToBlock(bb, c) |
        pred = bb.getLastElement() and
        succ(pred, succ, c) and
        // Exit this split if we can no longer reach a correlated condition
        not super.getSubKind().canReachCorrelatedCondition(succ)
      )
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      exists(PreBasicBlock bb | this.appliesToBlock(bb, c) |
        last = bb.getLastElement() and
        scopeLast(scope, last, c)
      )
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      exists(PreBasicBlock bb, Completion c0 | this.appliesToBlock(bb, c0) |
        pred = bb.getAnElement() and
        this.appliesSucc(pred, succ, c) and
        (
          pred = bb.getLastElement()
          implies
          (
            // We must still be able to reach a correlated condition to stay in this split
            super.getSubKind().canReachCorrelatedCondition(succ) and
            c = c0
          )
        )
      )
    }
  }
}

module LoopSplitting {
  private import semmle.code.csharp.controlflow.Guards as Guards
  private import PreBasicBlocks

  /** Holds if `ce` is guarded by a (non-)empty check, as specified by `v`. */
  private predicate emptinessGuarded(
    Guards::Guard g, Guards::EnumerableCollectionExpr ce,
    Guards::AbstractValues::EmptyCollectionValue v
  ) {
    exists(PreBasicBlock bb | Guards::Internal::preControls(g, bb, v) |
      PreSsa::adjacentReadPairSameVar(g, ce) and
      bb.getAnElement() = ce
    )
  }

  /**
   * A loop where the body is guaranteed to be executed at least once, and hence
   * can be unrolled in the control flow graph, or where the body is guaranteed
   * to never be executed, and hence can be removed from the control flow graph.
   */
  abstract class AnalyzableLoopStmt extends LoopStmt {
    /** Holds if the step `pred --c--> succ` should start the split. */
    abstract predicate start(AstNode pred, AstNode succ, Completion c);

    /** Holds if the step `pred --c--> succ` should stop the split. */
    abstract predicate stop(AstNode pred, AstNode succ, Completion c);

    /**
     * Holds if any step `pred --c--> _` should be pruned from the control flow graph.
     */
    abstract predicate pruneLoopCondition(AstNode pred, ConditionalCompletion c);

    /**
     * Holds if the body is guaranteed to be executed at least once. If not, the
     * body is guaranteed to never be executed.
     */
    abstract predicate isUnroll();
  }

  private class AnalyzableForeachStmt extends AnalyzableLoopStmt, ForeachStmt {
    Guards::AbstractValues::EmptyCollectionValue v;

    AnalyzableForeachStmt() {
      /*
       * We use `unique` to avoid degenerate cases like
       * ```csharp
       * if (xs.Length == 0)
       *     return;
       * if (xs.Length > 0)
       *     return;
       * foreach (var x in xs)
       *     ....
       * ```
       * where the iterator expression `xs` is guarded by both an emptiness check
       * and a non-emptiness check.
       */

      v =
        unique(Guards::AbstractValues::EmptyCollectionValue v0 |
          emptinessGuarded(_, this.getIterableExpr(), v0)
          or
          this.getIterableExpr() = v0.getAnExpr()
        |
          v0
        )
    }

    override predicate start(AstNode pred, AstNode succ, Completion c) {
      last(this.getIterableExpr(), pred, c) and
      succ = this
    }

    override predicate stop(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      succ(pred, succ, c)
    }

    override predicate pruneLoopCondition(AstNode pred, ConditionalCompletion c) {
      pred = this and
      c = any(EmptinessCompletion ec | if v.isEmpty() then not ec.isEmpty() else ec.isEmpty())
    }

    override predicate isUnroll() { v.isNonEmpty() }
  }

  /**
   * A split for loops where the body is guaranteed to be executed at least once, or
   * guaranteed to never be executed. For example, in
   *
   * ```csharp
   * void M(string[] args)
   * {
   *     if (args.Length == 0)
   *         return;
   *     foreach (var arg in args)
   *         System.Console.WriteLine(args);
   * }
   * ```
   *
   * the `foreach` loop is guaranteed to be executed at least once, as a result of the
   * `args.Length == 0` check.
   */
  class LoopSplit extends Split, TLoopSplit {
    AnalyzableLoopStmt loop;

    LoopSplit() { this = TLoopSplit(loop) }

    override string toString() {
      if loop.isUnroll()
      then result = "unroll (line " + loop.getLocation().getStartLine() + ")"
      else result = "skip (line " + loop.getLocation().getStartLine() + ")"
    }
  }

  pragma[noinline]
  private Callable enclosingCallable(AnalyzableLoopStmt loop) {
    result = loop.getEnclosingCallable()
  }

  private int getListOrder(AnalyzableLoopStmt loop) {
    exists(Callable c, int r | c = enclosingCallable(loop) |
      result = r + BooleanSplitting::getNextListOrder() - 1 and
      loop =
        rank[r](AnalyzableLoopStmt loop0, Location l |
          enclosingCallable(loop0) = c and
          l = loop0.getLocation()
        |
          loop0 order by l.getStartLine(), l.getStartColumn()
        )
    )
  }

  int getNextListOrder() {
    result = max([getListOrder(_) + 1, BooleanSplitting::getNextListOrder()])
  }

  private class LoopSplitKind extends SplitKind, TLoopSplitKind {
    private AnalyzableLoopStmt loop;

    LoopSplitKind() { this = TLoopSplitKind(loop) }

    override int getListOrder() { result = getListOrder(loop) }

    override string toString() { result = "Unroll" }
  }

  private class LoopUnrollingSplitImpl extends SplitImpl instanceof LoopSplit {
    AnalyzableLoopStmt loop;

    LoopUnrollingSplitImpl() { this = TLoopSplit(loop) }

    override LoopSplitKind getKind() { result = TLoopSplitKind(loop) }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      loop.start(pred, succ, c)
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) { none() }

    /**
     * Holds if this split applies to control flow element `pred`, where `pred`
     * is a valid predecessor.
     */
    private predicate appliesToPredecessor(AstNode pred, Completion c) {
      this.appliesTo(pred) and
      (succ(pred, _, c) or scopeLast(_, pred, c)) and
      not loop.pruneLoopCondition(pred, c)
    }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      this.appliesToPredecessor(pred, c) and
      loop.stop(pred, succ, c)
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      this.appliesToPredecessor(last, c) and
      scopeLast(scope, last, c)
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesToPredecessor(pred, c) and
      this.appliesSucc(pred, succ, c) and
      not loop.stop(pred, succ, c)
    }
  }
}
