/**
 * INTERNAL: Do not use.
 *
 * Provides a basic block implementation on control flow elements. That is,
 * a "pre-CFG" where the nodes are (unsplit) control flow elements and the
 * successor relation is `succ = succ(pred, _)`.
 *
 * The logic is duplicated from the implementation in `BasicBlocks.qll`, and
 * being an internal class, all predicate documentation has been removed.
 */

import csharp
private import Completion
private import ControlFlowGraphImpl
private import semmle.code.csharp.controlflow.ControlFlowGraph::ControlFlow as Cfg
private import codeql.controlflow.BasicBlock as BB

private predicate startsBB(ControlFlowElement cfe) {
  not succ(_, cfe, _) and
  (
    succ(cfe, _, _)
    or
    scopeLast(_, cfe, _)
  )
  or
  strictcount(ControlFlowElement pred, Completion c | succ(pred, cfe, c)) > 1
  or
  succ(_, cfe, any(ConditionalCompletion c))
  or
  exists(ControlFlowElement pred, int i |
    succ(pred, cfe, _) and
    i = count(ControlFlowElement succ, Completion c | succ(pred, succ, c))
  |
    i > 1
    or
    i = 1 and
    scopeLast(_, pred, _)
  )
}

private predicate intraBBSucc(ControlFlowElement pred, ControlFlowElement succ) {
  succ(pred, succ, _) and
  not startsBB(succ)
}

private predicate bbIndex(ControlFlowElement bbStart, ControlFlowElement cfe, int i) =
  shortestDistances(startsBB/1, intraBBSucc/2)(bbStart, cfe, i)

private predicate succBB(PreBasicBlock pred, PreBasicBlock succ) { succ = pred.getASuccessor() }

private predicate entryBB(PreBasicBlock bb) { scopeFirst(_, bb) }

private predicate bbIDominates(PreBasicBlock dom, PreBasicBlock bb) =
  idominance(entryBB/1, succBB/2)(_, dom, bb)

class PreBasicBlock extends ControlFlowElement {
  PreBasicBlock() { startsBB(this) }

  PreBasicBlock getASuccessor(Cfg::SuccessorType t) {
    succ(this.getLastNode(), result, any(Completion c | t = c.getAMatchingSuccessorType()))
  }

  deprecated PreBasicBlock getASuccessorByType(Cfg::SuccessorType t) {
    result = this.getASuccessor(t)
  }

  PreBasicBlock getASuccessor() { result = this.getASuccessor(_) }

  PreBasicBlock getAPredecessor() { result.getASuccessor() = this }

  ControlFlowElement getNode(int pos) { bbIndex(this, result, pos) }

  deprecated ControlFlowElement getElement(int pos) { result = this.getNode(pos) }

  ControlFlowElement getAnElement() { result = this.getNode(_) }

  ControlFlowElement getFirstElement() { result = this }

  ControlFlowElement getLastNode() { result = this.getNode(this.length() - 1) }

  deprecated ControlFlowElement getLastElement() { result = this.getLastNode() }

  int length() { result = strictcount(this.getAnElement()) }

  PreBasicBlock getImmediateDominator() { bbIDominates(result, this) }

  predicate immediatelyDominates(PreBasicBlock bb) { bbIDominates(this, bb) }

  pragma[inline]
  predicate strictlyDominates(PreBasicBlock bb) { this.immediatelyDominates+(bb) }

  pragma[inline]
  predicate dominates(PreBasicBlock bb) {
    bb = this
    or
    this.strictlyDominates(bb)
  }

  predicate inDominanceFrontier(PreBasicBlock df) {
    this = df.getAPredecessor() and not bbIDominates(this, df)
    or
    exists(PreBasicBlock prev | prev.inDominanceFrontier(df) |
      bbIDominates(this, prev) and
      not bbIDominates(this, df)
    )
  }

  /** Unsupported. Do not use. */
  predicate strictlyPostDominates(PreBasicBlock bb) { none() }

  /** Unsupported. Do not use. */
  predicate postDominates(PreBasicBlock bb) {
    this.strictlyPostDominates(bb) or
    this = bb
  }
}

private Completion getConditionalCompletion(ConditionalCompletion cc) {
  result.getInnerCompletion() = cc
}

pragma[nomagic]
private predicate conditionBlockImmediatelyControls(
  ConditionBlock cond, PreBasicBlock succ, ConditionalCompletion cc
) {
  exists(ControlFlowElement last, Completion c |
    last = cond.getLastNode() and
    c = getConditionalCompletion(cc) and
    succ(last, succ, c) and
    // In the pre-CFG, we need to account for case where one predecessor node has
    // two edges to the same successor node. Assertion expressions are examples of
    // such nodes.
    not exists(Completion other |
      succ(last, succ, other) and
      other != c
    ) and
    forall(PreBasicBlock pred | pred = succ.getAPredecessor() and pred != cond |
      succ.dominates(pred)
    )
  )
}

class ConditionBlock extends PreBasicBlock {
  ConditionBlock() {
    exists(Completion c | c = getConditionalCompletion(_) |
      succ(this.getLastNode(), _, c)
      or
      scopeLast(_, this.getLastNode(), c)
    )
  }

  pragma[nomagic]
  predicate controls(PreBasicBlock controlled, Cfg::ConditionalSuccessor s) {
    exists(PreBasicBlock succ, ConditionalCompletion c |
      conditionBlockImmediatelyControls(this, succ, c)
    |
      succ.dominates(controlled) and
      s = c.getAMatchingSuccessorType()
    )
  }
}

module PreCfg implements BB::CfgSig<Location> {
  class ControlFlowNode = ControlFlowElement;

  class BasicBlock = PreBasicBlock;

  class EntryBasicBlock extends BasicBlock {
    EntryBasicBlock() { entryBB(this) }
  }

  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
    conditionBlockImmediatelyControls(bb1, bb2, _)
  }
}
