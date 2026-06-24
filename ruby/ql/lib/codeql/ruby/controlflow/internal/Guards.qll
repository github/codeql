overlay[local]
module;

private import codeql.ruby.CFG

/** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
pragma[nomagic]
predicate guardControlsBlock(CfgNodes::AstCfgNode guard, BasicBlock bb, boolean branch) {
  exists(BasicBlock conditionBlock, ConditionalSuccessor s |
    guard = conditionBlock.getLastNode() and
    s.getValue() = branch and
    conditionBlock.edgeDominates(bb, s)
  )
  or
  exists(BasicBlock whenBlock, ConditionalSuccessor s, ControlFlowNode guardNode, int i |
    guardNode.isAfter(guard.(CfgNodes::ExprNodes::WhenClauseCfgNode).getAstNode()) and
    whenBlock.getNode(i) = guardNode and
    i != 0 and
    guardNode = any(ControlFlowNode n).getASuccessor(s) and
    s.getValue() = branch and
    whenBlock.dominates(bb)
  )
}
