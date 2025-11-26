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
  newtype TSplitKind = TConditionalCompletionSplitKind()

  cached
  newtype TSplit = TConditionalCompletionSplit(ConditionalCompletion c)
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
  }

  /**
   * Holds if `obinit` is an object initializer method that performs the initialization
   * of a member via assignment `init`.
   */
  predicate obinitInitializes(ObjectInitMethod obinit, AssignExpr init) {
    exists(InitializedInstanceMember m |
      obinit.getDeclaringType().getAMember() = m and
      init = m.getInitializer()
    )
  }

  /**
   * Gets the `i`th member initializer expression for object initializer method `obinit`
   * in compilation `comp`.
   */
  AssignExpr initializedInstanceMemberOrder(ObjectInitMethod obinit, CompilationExt comp, int i) {
    obinitInitializes(obinit, result) and
    result =
      rank[i + 1](AssignExpr ae0, Location l |
        obinitInitializes(obinit, ae0) and
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
  AssignExpr lastInitializer(ObjectInitMethod obinit, CompilationExt comp) {
    exists(int i |
      result = initializedInstanceMemberOrder(obinit, comp, i) and
      not exists(initializedInstanceMemberOrder(obinit, comp, i + 1))
    )
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
    override int getListOrder() { result = 0 }

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
}
