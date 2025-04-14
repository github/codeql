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

module ConditionalCompletionSplitting {
  /** A split for conditional completions. */
  class ConditionalCompletionSplit extends Split, TConditionalCompletionSplit {
    ConditionalCompletion completion;

    ConditionalCompletionSplit() { this = TConditionalCompletionSplit(completion) }

    ConditionalCompletion getCompletion() { result = completion }

    override string toString() { result = completion.toString() }
  }

  private class ConditionalCompletionSplitKind_ extends SplitKind, TConditionalCompletionSplitKind {
    override int getListOrder() { result = 0 }

    override predicate isEnabled(ControlFlowElement n) { this.appliesTo(n) }

    override string toString() { result = "ConditionalCompletion" }
  }

  module ConditionalCompletionSplittingInput {
    private import Completion as Comp

    class ConditionalCompletion = Comp::ConditionalCompletion;

    class ConditionalCompletionSplitKind extends ConditionalCompletionSplitKind_, TSplitKind { }

    class ConditionalCompletionSplit = ConditionalCompletionSplitting::ConditionalCompletionSplit;

    bindingset[parent, parentCompletion]
    private predicate condPropagateAstExpr(
      AstNode parent, ConditionalCompletion parentCompletion, AstNode child,
      ConditionalCompletion childCompletion
    ) {
      child = parent.(NotExpr).getOperand().getFullyConverted() and
      childCompletion.(BooleanCompletion).getDual() = parentCompletion
      or
      childCompletion = parentCompletion and
      (
        child = parent.(LogicalAndExpr).getAnOperand().getFullyConverted()
        or
        child = parent.(LogicalOrExpr).getAnOperand().getFullyConverted()
        or
        child = parent.(IfExpr).getBranch(_).getFullyConverted()
        or
        exists(Exprs::Conversions::ConversionOrIdentityTree conv |
          parent = conv.getAst() and
          conv.convertsFrom(child)
        )
      )
    }

    bindingset[parent, parentCompletion]
    predicate condPropagateExpr(
      ControlFlowElement parent, ConditionalCompletion parentCompletion, ControlFlowElement child,
      ConditionalCompletion childCompletion
    ) {
      condPropagateAstExpr(parent.asAstNode(), parentCompletion, child.asAstNode(), childCompletion)
    }
  }
}
