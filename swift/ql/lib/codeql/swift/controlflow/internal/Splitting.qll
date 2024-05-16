/**
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

private import swift
private import Completion
private import ControlFlowGraphImpl
private import AstControlFlowTrees
private import ControlFlowElements
private import ControlFlowGraphImplSpecific::CfgInput as CfgInput

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

    ConditionalCompletion getCompletion() { result = completion }

    override string toString() { result = completion.toString() }
  }

  private class ConditionalCompletionSplitKind extends SplitKind, TConditionalCompletionSplitKind {
    override int getListOrder() { result = 0 }

    override predicate isEnabled(ControlFlowElement n) { this.appliesTo(n) }

    override string toString() { result = "ConditionalCompletion" }
  }

  private class ConditionalCompletionSplitImpl extends SplitImpl instanceof ConditionalCompletionSplit
  {
    override ConditionalCompletionSplitKind getKind() { any() }

    override predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      succ(pred, succ, c) and
      last(succ, _, super.getCompletion()) and
      (
        astLast(succ.asAstNode().(NotExpr).getOperand().getFullyConverted(), pred, c) and
        super.getCompletion().(BooleanCompletion).getDual() = c
        or
        astLast(succ.asAstNode().(LogicalAndExpr).getAnOperand().getFullyConverted(), pred, c) and
        super.getCompletion() = c
        or
        astLast(succ.asAstNode().(LogicalOrExpr).getAnOperand().getFullyConverted(), pred, c) and
        super.getCompletion() = c
        or
        succ.asAstNode() =
          any(IfExpr ce |
            astLast(ce.getBranch(_).getFullyConverted(), pred, c) and
            super.getCompletion() = c
          )
        or
        exists(Expr e, Exprs::Conversions::ConversionOrIdentityTree conv |
          succ.asAstNode() = conv.getAst() and
          conv.convertsFrom(e) and
          astLast(e, pred, c) and
          super.getCompletion() = c
        )
      )
    }

    override predicate hasEntryScope(CfgInput::CfgScope scope, ControlFlowElement succ) { none() }

    override predicate hasExit(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      this.appliesTo(pred) and
      succ(pred, succ, c) and
      if c instanceof ConditionalCompletion then super.getCompletion() = c else any()
    }

    override predicate hasExitScope(CfgInput::CfgScope scope, ControlFlowElement last, Completion c) {
      this.appliesTo(last) and
      succExit(scope, last, c) and
      if c instanceof ConditionalCompletion then super.getCompletion() = c else any()
    }

    override predicate hasSuccessor(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      none()
    }
  }
}
