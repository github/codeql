/**
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

private import powershell
private import Completion
private import ControlFlowGraphImpl
private import Cfg::SuccessorTypes
private import semmle.code.powershell.controlflow.ControlFlowGraph as Cfg

cached
private module Cached {
  cached
  newtype TSplitKind =
    TConditionalCompletionSplitKind()

  cached
  newtype TSplit =
    TConditionalCompletionSplit(ConditionalCompletion c)
}

import Cached

/** A split for a control flow node. */
class Split extends TSplit {
  /** Gets a textual representation of this split. */
  string toString() { none() }
}

private module ConditionalCompletionSplitting {
  /**
   * A split for conditional completions.
   */
  class ConditionalCompletionSplit extends Split, TConditionalCompletionSplit {
    ConditionalCompletion completion;

    ConditionalCompletionSplit() { this = TConditionalCompletionSplit(completion) }

    override string toString() { result = completion.toString() }
  }

  // private class ConditionalCompletionSplitKind extends SplitKind, TConditionalCompletionSplitKind {
  //   override int getListOrder() { result = 0 }

  //   override predicate isEnabled(Ast n) { this.appliesTo(n) }

  //   override string toString() { result = "ConditionalCompletion" }
  // }

  int getNextListOrder() { result = 1 }

//   private class ConditionalCompletionSplitImpl extends SplitImpl instanceof ConditionalCompletionSplit
//   {
//     ConditionalCompletion completion;

//     ConditionalCompletionSplitImpl() { this = TConditionalCompletionSplit(completion) }

//     override ConditionalCompletionSplitKind getKind() { any() }

//     override predicate hasEntry(Ast pred, Ast succ, Completion c) {
//       succ(pred, succ, c) and
//       last(succ, _, completion) and
//       none() // TODO
//     }

//     override predicate hasEntryScope(Cfg::CfgScope scope, Ast succ) { none() }

//     override predicate hasExit(Ast pred, Ast succ, Completion c) {
//       this.appliesTo(pred) and
//       succ(pred, succ, c) and
//       if c instanceof ConditionalCompletion then completion = c else any()
//     }

//     override predicate hasExitScope(Cfg::CfgScope scope, Ast last, Completion c) {
//       this.appliesTo(last) and
//       succExit(scope, last, c) and
//       if c instanceof ConditionalCompletion then completion = c else any()
//     }

//     override predicate hasSuccessor(Ast pred, Ast succ, Completion c) { none() }
//   }
}

class ConditionalCompletionSplit = ConditionalCompletionSplitting::ConditionalCompletionSplit;

