import csharp
import semmle.code.csharp.controlflow.internal.Completion
import semmle.code.csharp.controlflow.internal.PreBasicBlocks
import ControlFlow
import ControlFlow::Internal

predicate bbStartInconsistency(ControlFlowElement cfe) {
  exists(ControlFlow::BasicBlock bb | bb.getFirstNode() = cfe.getAControlFlowNode()) and
  not cfe = any(PreBasicBlock bb).getFirstElement()
}

predicate bbSuccInconsistency(ControlFlowElement pred, ControlFlowElement succ) {
  exists(ControlFlow::BasicBlock predBB, ControlFlow::BasicBlock succBB |
    predBB.getLastNode() = pred.getAControlFlowNode() and
    succBB = predBB.getASuccessor() and
    succBB.getFirstNode() = succ.getAControlFlowNode()
  ) and
  not exists(PreBasicBlock predBB, PreBasicBlock succBB |
    predBB.getLastElement() = pred and
    succBB = predBB.getASuccessor() and
    succBB.getFirstElement() = succ
  )
}

predicate bbIntraSuccInconsistency(ControlFlowElement pred, ControlFlowElement succ) {
  exists(ControlFlow::BasicBlock bb, int i |
    pred.getAControlFlowNode() = bb.getNode(i) and
    succ.getAControlFlowNode() = bb.getNode(i + 1)
  ) and
  not exists(PreBasicBlock bb |
    bb.getLastElement() = pred and
    bb.getASuccessor().getFirstElement() = succ
  ) and
  not exists(PreBasicBlock bb, int i |
    bb.getElement(i) = pred and
    bb.getElement(i + 1) = succ
  )
}

query predicate preBasicBlockConsistency(ControlFlowElement cfe1, ControlFlowElement cfe2, string s) {
  bbStartInconsistency(cfe1) and
  cfe2 = cfe1 and
  s = "start inconsistency"
  or
  bbSuccInconsistency(cfe1, cfe2) and
  s = "succ inconsistency"
  or
  bbIntraSuccInconsistency(cfe1, cfe2) and
  s = "intra succ inconsistency"
}

query predicate nonUniqueSetRepresentation(Splits s1, Splits s2) {
  forex(Nodes::Split s | s = s1.getASplit() | s = s2.getASplit()) and
  forex(Nodes::Split s | s = s2.getASplit() | s = s1.getASplit()) and
  s1 != s2
}

query predicate breakInvariant2(
  ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
  SplitInternal split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split = predSplits.getASplit() and
  split.hasSuccessor(pred, succ, c) and
  not split = succSplits.getASplit()
}

query predicate breakInvariant3(
  ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
  SplitInternal split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split = predSplits.getASplit() and
  split.hasExit(pred, succ, c) and
  not split.hasEntry(pred, succ, c) and
  split = succSplits.getASplit()
}

query predicate breakInvariant4(
  ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
  SplitInternal split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split.hasEntry(pred, succ, c) and
  not split.getKind() = predSplits.getASplit().getKind() and
  not split = succSplits.getASplit()
}

query predicate breakInvariant5(
  ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
  SplitInternal split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split = succSplits.getASplit() and
  not (split.hasSuccessor(pred, succ, c) and split = predSplits.getASplit()) and
  not split.hasEntry(pred, succ, c)
}

query predicate multipleSuccessors(
  ControlFlow::Node node, SuccessorType t, ControlFlow::Node successor
) {
  not node instanceof ControlFlow::Nodes::EntryNode and
  strictcount(node.getASuccessorByType(t)) > 1 and
  successor = node.getASuccessorByType(t)
}
