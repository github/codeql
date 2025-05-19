/**
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

private import powershell
private import Completion as Comp
private import Comp
private import ControlFlowGraphImpl
private import Cfg::SuccessorTypes
private import semmle.code.powershell.controlflow.ControlFlowGraph as Cfg

cached
private module Cached {
  cached
  newtype TSplitKind = TConditionalCompletionSplitKind()

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
  class ConditionalCompletionSplit extends Split, TConditionalCompletionSplit {
    ConditionalCompletion completion;

    ConditionalCompletionSplit() { this = TConditionalCompletionSplit(completion) }

    ConditionalCompletion getCompletion() { result = completion }

    override string toString() { result = completion.toString() }
  }

  private class ConditionalCompletionSplitKind_ extends SplitKind, TConditionalCompletionSplitKind {
    override int getListOrder() { result = 0 }

    override predicate isEnabled(Ast n) { this.appliesTo(n) }

    override string toString() { result = "ConditionalCompletion" }
  }

  module ConditionalCompletionSplittingInput {
    private import Completion as Comp

    class ConditionalCompletion = Comp::ConditionalCompletion;

    class ConditionalCompletionSplitKind extends ConditionalCompletionSplitKind_, TSplitKind { }

    class ConditionalCompletionSplit = ConditionalCompletionSplitting::ConditionalCompletionSplit;

    bindingset[parent, parentCompletion]
    predicate condPropagateExpr(
      Ast parent, ConditionalCompletion parentCompletion, Ast child,
      ConditionalCompletion childCompletion
    ) {
      child = parent.(NotExpr).getOperand() and
      childCompletion.(BooleanCompletion).getDual() = parentCompletion
      or
      childCompletion = parentCompletion and
      (
        child = parent.(LogicalAndExpr).getAnOperand()
        or
        child = parent.(LogicalOrExpr).getAnOperand()
        or
        child = parent.(ConditionalExpr).getBranch(_)
        or
        child = parent.(ParenExpr).getExpr()
      )
    }

    int getNextListOrder() { result = 1 }

    private class ConditionalCompletionSplitImpl extends SplitImplementations::ConditionalCompletionSplitting::ConditionalCompletionSplitImpl
    { }
  }
}

class ConditionalCompletionSplit = ConditionalCompletionSplitting::ConditionalCompletionSplit;
