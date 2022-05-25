/**
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

private import swift
private import Completion
private import ControlFlowGraphImpl
private import codeql.swift.controlflow.ControlFlowGraph

cached
private module Cached {
  cached
  newtype TSplitKind = TConditionalCompletionSplitKind() { forceCachingInSameStage() }

  cached
  newtype TSplit = TConditionalCompletionSplit(ConditionalCompletion c)
}

import Cached

/** A split for a control flow node. */
class Split extends TSplit {
  /** Gets a textual representation of this split. */
  string toString() { none() }
}

private module ConditionalCompletionSplitting {
  /** A split for conditional completions. */
  class ConditionalCompletionSplit extends Split, TConditionalCompletionSplit {
    ConditionalCompletion completion;

    ConditionalCompletionSplit() { this = TConditionalCompletionSplit(completion) }

    override string toString() { result = completion.toString() }
  }

  private class ConditionalCompletionSplitKind extends SplitKind, TConditionalCompletionSplitKind {
    override int getListOrder() { result = 0 }

    override predicate isEnabled(AstNode n) { this.appliesTo(n) }

    override string toString() { result = "ConditionalCompletion" }
  }

  private class ConditionalCompletionSplitImpl extends SplitImpl, ConditionalCompletionSplit {
    override ConditionalCompletionSplitKind getKind() { any() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      succ(pred, succ, c) and
      last(succ, _, completion) and
      (
        last(succ.(NotExpr).getOperand().getFullyConverted(), pred, c) and
        completion.(BooleanCompletion).getDual() = c
        or
        last(succ.(LogicalAndExpr).getAnOperand().getFullyConverted(), pred, c) and
        completion = c
        or
        last(succ.(LogicalOrExpr).getAnOperand().getFullyConverted(), pred, c) and
        completion = c
        or
        succ =
          any(IfExpr ce |
            last(ce.getBranch(_).getFullyConverted(), pred, c) and
            completion = c
          )
        or
        exists(Expr e |
          succ.(Exprs::Conversions::ConversionOrIdentityTree).convertsFrom(e) and
          last(e, pred, c) and
          completion = c
        )
      )
    }

    override predicate hasEntryScope(CfgScope scope, AstNode succ) { none() }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      this.appliesTo(pred) and
      succ(pred, succ, c) and
      if c instanceof ConditionalCompletion then completion = c else any()
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      this.appliesTo(last) and
      succExit(scope, last, c) and
      if c instanceof ConditionalCompletion then completion = c else any()
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) { none() }
  }
}
