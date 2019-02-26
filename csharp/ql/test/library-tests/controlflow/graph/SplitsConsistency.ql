import csharp
import semmle.code.csharp.controlflow.internal.Completion
import ControlFlow
import ControlFlow::Internal

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
  split = succSplits.getASplit()
}

query predicate breakInvariant4(
  ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
  SplitInternal split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split.hasEntry(pred, succ, c) and
  not split = predSplits.getASplit() and
  not split = succSplits.getASplit()
}

query predicate breakInvariant5(
  ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
  SplitInternal split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split = succSplits.getASplit() and
  not (split.hasSuccessor(pred, succ, c) and split = predSplits.getASplit()) and
  not (split.hasEntry(pred, succ, c) and not split = predSplits.getASplit())
}
