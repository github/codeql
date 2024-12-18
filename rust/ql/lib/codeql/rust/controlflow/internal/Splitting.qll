private import rust
private import ControlFlowGraphImpl
private import Scope

cached
private module Cached {
  private import codeql.rust.internal.CachedStages

  cached
  newtype TSplitKind = TConditionalCompletionSplitKind() { Stages::CfgStage::ref() }

  cached
  newtype TSplit = TConditionalCompletionSplit(ConditionalCompletion c)
}

import Cached

/** A split for a control flow node. */
abstract private class Split_ extends TSplit {
  /** Gets a textual representation of this split. */
  abstract string toString();
}

final class Split = Split_;

module ConditionalCompletionSplitting {
  /**
   * A split for conditional completions. For example, in
   *
   * ```rust
   * if x && !y {
   *   // ...
   * }
   * ```
   *
   * we record whether `x`, `y`, and `!y` evaluate to `true` or `false`, and restrict
   * the edges out of `!y` and `x && !y` accordingly.
   */
  class ConditionalCompletionSplit extends Split_, TConditionalCompletionSplit {
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
      child = parent.(LogicalNotExpr).getExpr() and
      childCompletion.getDual() = parentCompletion
      or
      (
        childCompletion = parentCompletion
        or
        // needed for `let` expressions
        childCompletion.(MatchCompletion).getValue() =
          parentCompletion.(BooleanCompletion).getValue()
      ) and
      (
        child = parent.(BinaryLogicalOperation).getAnOperand()
        or
        parent = any(IfExpr ie | child = [ie.getThen(), ie.getElse()])
        or
        child = parent.(MatchExpr).getAnArm().getExpr()
        or
        child = parent.(BlockExpr).getStmtList().getTailExpr()
        or
        child = parent.(PatternTrees::PreOrderPatTree).getPat(_) and
        childCompletion.(MatchCompletion).failed()
        or
        child = parent.(PatternTrees::PostOrderPatTree).getPat(_)
      )
    }
  }

  private class ConditionalCompletionSplitImpl extends SplitImplementations::ConditionalCompletionSplitting::ConditionalCompletionSplitImpl
  {
    /**
     * Gets a `break` expression whose target can have a Boolean completion that
     * matches this split.
     */
    private BreakExpr getABreakExpr(Expr target) {
      target = result.getTarget() and
      last(target, _, this.getCompletion())
    }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      super.hasEntry(pred, succ, c)
      or
      succ(pred, succ, c) and
      last(succ.(BreakExpr).getExpr(), pred, c) and
      succ = this.getABreakExpr(_) and
      c = this.getCompletion()
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      super.hasSuccessor(pred, succ, c)
      or
      this.appliesTo(pred) and
      succ(pred, succ, c) and
      pred = this.getABreakExpr(succ)
    }
  }

  int getNextListOrder() { result = 1 }
}
