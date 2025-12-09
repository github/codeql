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

cached
private module Cached {
  private import semmle.code.csharp.Caching

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
