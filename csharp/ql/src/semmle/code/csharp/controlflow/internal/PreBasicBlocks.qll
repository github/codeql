/**
 * INTERNAL: Do not use.
 *
 * Provides a basic block implementation on control flow elements. That is,
 * a "pre-CFG" where the nodes are (unsplit) control flow elements and the
 * successor releation is `succ = succ(pred, _)`.
 *
 * The logic is duplicated from the implementation in `BasicBlocks.qll`, and
 * being an internal class, all predicate documentation has been removed.
 */

import csharp
private import semmle.code.csharp.controlflow.internal.Completion
private import semmle.code.csharp.controlflow.ControlFlowGraph::ControlFlow
private import Internal::Successor

private predicate startsBB(ControlFlowElement cfe) {
  not cfe = succ(_, _) and
  (
    exists(succ(cfe, _))
    or
    exists(succExit(cfe, _))
  )
  or
  strictcount(ControlFlowElement pred, Completion c | cfe = succ(pred, c)) > 1
  or
  exists(ControlFlowElement pred, int i |
    cfe = succ(pred, _) and
    i = count(ControlFlowElement succ, Completion c | succ = succ(pred, c))
  |
    i > 1
    or
    i = 1 and
    exists(succExit(pred, _))
  )
}

private predicate intraBBSucc(ControlFlowElement pred, ControlFlowElement succ) {
  succ = succ(pred, _) and
  not startsBB(succ)
}

private predicate bbIndex(ControlFlowElement bbStart, ControlFlowElement cfe, int i) =
  shortestDistances(startsBB/1, intraBBSucc/2)(bbStart, cfe, i)

private predicate succBB(PreBasicBlock pred, PreBasicBlock succ) { succ = pred.getASuccessor() }

private predicate entryBB(PreBasicBlock bb) { bb = succEntry(_) }

private predicate bbIDominates(PreBasicBlock dom, PreBasicBlock bb) =
  idominance(entryBB/1, succBB/2)(_, dom, bb)

class PreBasicBlock extends ControlFlowElement {
  PreBasicBlock() { startsBB(this) }

  PreBasicBlock getASuccessorByType(SuccessorType t) {
    result = succ(this.getLastElement(), any(Completion c | t.matchesCompletion(c)))
  }

  PreBasicBlock getASuccessor() { result = this.getASuccessorByType(_) }

  PreBasicBlock getAPredecessor() { result.getASuccessor() = this }

  ControlFlowElement getElement(int pos) { bbIndex(this, result, pos) }

  ControlFlowElement getAnElement() { result = this.getElement(_) }

  ControlFlowElement getFirstElement() { result = this }

  ControlFlowElement getLastElement() { result = this.getElement(length() - 1) }

  int length() { result = strictcount(getAnElement()) }

  predicate immediatelyDominates(PreBasicBlock bb) { bbIDominates(this, bb) }

  predicate strictlyDominates(PreBasicBlock bb) { this.immediatelyDominates+(bb) }

  predicate dominates(PreBasicBlock bb) {
    bb = this
    or
    this.strictlyDominates(bb)
  }

  predicate inDominanceFrontier(PreBasicBlock df) {
    this.dominatesPredecessor(df) and
    not this.strictlyDominates(df)
  }

  private predicate dominatesPredecessor(PreBasicBlock df) { this.dominates(df.getAPredecessor()) }
}

private Completion getConditionalCompletion(ConditionalCompletion cc) {
  result.getInnerCompletion() = cc
}

class ConditionBlock extends PreBasicBlock {
  ConditionBlock() {
    strictcount(Completion c |
      c = getConditionalCompletion(_) and
      (
        exists(succ(this.getLastElement(), c))
        or
        exists(succExit(this.getLastElement(), c))
      )
    ) > 1
  }

  private predicate immediatelyControls(PreBasicBlock succ, ConditionalCompletion cc) {
    exists(ControlFlowElement last, Completion c |
      last = this.getLastElement() and
      c = getConditionalCompletion(cc) and
      succ = succ(last, c) and
      // In the pre-CFG, we need to account for case where one predecessor node has
      // two edges to the same successor node. Assertion expressions are examples of
      // such nodes.
      not exists(Completion other |
        succ = succ(last, other) and
        other != c
      ) and
      forall(PreBasicBlock pred | pred = succ.getAPredecessor() and pred != this |
        succ.dominates(pred)
      )
    )
  }

  pragma[nomagic]
  predicate controls(PreBasicBlock controlled, SuccessorTypes::ConditionalSuccessor s) {
    exists(PreBasicBlock succ, ConditionalCompletion c | immediatelyControls(succ, c) |
      succ.dominates(controlled) and
      s.matchesCompletion(c)
    )
  }
}
