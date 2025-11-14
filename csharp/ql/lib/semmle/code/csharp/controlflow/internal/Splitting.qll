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
    TConditionalCompletionSplitKind()

  cached
  newtype TSplit =
    TInitializerSplit(Constructor c) { InitializerSplitting::constructorInitializes(c, _) } or
    TConditionalCompletionSplit(ConditionalCompletion c)
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
