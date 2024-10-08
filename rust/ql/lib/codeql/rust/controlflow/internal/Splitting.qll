private import rust
private import ControlFlowGraphImpl
private import Scope

cached
private module Cached {
  cached
  newtype TSplitKind = TConditionalCompletionSplitKind()

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

private module ConditionalCompletionSplitting {
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

    override string toString() { result = completion.toString() }
  }

  private class ConditionalCompletionSplitKind extends SplitKind, TConditionalCompletionSplitKind {
    override int getListOrder() { result = 0 }

    override predicate isEnabled(AstNode cfe) { this.appliesTo(cfe) }

    override string toString() { result = "ConditionalCompletion" }
  }

  private class ConditionalCompletionSplitImpl extends SplitImpl instanceof ConditionalCompletionSplit
  {
    ConditionalCompletion completion;

    ConditionalCompletionSplitImpl() { this = TConditionalCompletionSplit(completion) }

    override ConditionalCompletionSplitKind getKind() { any() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      succ(pred, succ, c) and
      last(succ, _, completion) and
      (
        last(succ.(LogicalNotExpr).getExpr(), pred, c) and
        completion.(BooleanCompletion).getDual() = c
        or
        last(succ.(BinaryLogicalOperation).getAnOperand(), pred, c) and
        completion = c
        or
        succ =
          any(IfExpr ie |
            last([ie.getThen(), ie.getElse()], pred, c) and
            completion = c
          )
        or
        last(succ.(MatchExpr).getAnArm().getExpr(), pred, c) and
        completion = c
        or
        last(succ.(BlockExpr).getStmtList().getTailExpr(), pred, c) and
        completion = c
      )
      or
      succ(pred, succ, c) and
      last(succ.(BreakExpr).getExpr(), pred, c) and
      exists(AstNode target |
        succ(succ, target, _) and
        last(target, _, completion)
      ) and
      completion = c
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) { none() }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      this.appliesTo(pred) and
      succ(pred, succ, c) and
      if c instanceof ConditionalCompletion
      then completion = c
      else not this.hasSuccessor(pred, succ, c)
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      this.appliesTo(last) and
      scope.scopeLast(last, c) and
      if c instanceof ConditionalCompletion then completion = c else any()
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesTo(pred) and
      succ(pred, succ, c) and
      not c instanceof ConditionalCompletion
    }
  }
}
