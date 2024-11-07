private import codeql.ruby.CFG

/** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
pragma[nomagic]
predicate guardControlsBlock(CfgNodes::AstCfgNode guard, BasicBlock bb, boolean branch) {
  exists(ConditionBlock conditionBlock, SuccessorTypes::ConditionalSuccessor s |
    guard = conditionBlock.getLastNode() and
    s.getValue() = branch and
    conditionBlock.controls(bb, s)
  )
}
