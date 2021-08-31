private import codeql.ruby.AST
private import codeql.ruby.CFG
private import Completion
private import Splitting

query predicate nonUniqueSetRepresentation(Splits s1, Splits s2) {
  forex(Split s | s = s1.getASplit() | s = s2.getASplit()) and
  forex(Split s | s = s2.getASplit() | s = s1.getASplit()) and
  s1 != s2
}

query predicate breakInvariant2(
  AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split = predSplits.getASplit() and
  split.hasSuccessor(pred, succ, c) and
  not split = succSplits.getASplit()
}

query predicate breakInvariant3(
  AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split = predSplits.getASplit() and
  split.hasExit(pred, succ, c) and
  not split.hasEntry(pred, succ, c) and
  split = succSplits.getASplit()
}

query predicate breakInvariant4(
  AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split.hasEntry(pred, succ, c) and
  not split.getKind() = predSplits.getASplit().getKind() and
  not split = succSplits.getASplit()
}

query predicate breakInvariant5(
  AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split, Completion c
) {
  succSplits(pred, predSplits, succ, succSplits, c) and
  split = succSplits.getASplit() and
  not (split.hasSuccessor(pred, succ, c) and split = predSplits.getASplit()) and
  not split.hasEntry(pred, succ, c)
}

query predicate multipleSuccessors(CfgNode node, SuccessorType t, CfgNode successor) {
  not node instanceof CfgNodes::EntryNode and
  strictcount(node.getASuccessor(t)) > 1 and
  successor = node.getASuccessor(t)
}
